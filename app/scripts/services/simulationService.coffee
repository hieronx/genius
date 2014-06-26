app = angular.module("geniusApp")

app.factory "simulationService", ($compile, $rootScope) ->

  mRNA = 0
  Protein = 0

  run: (brick) ->
    # TODO for web worker
    # worker = new Worker('/scripts/workers/simulationWorker.js')
    # defer = $q.defer()
    
    # worker.postMessage bricks

    # worker.addEventListener 'message', (e) ->
    #   console.log('Worker said: ', e.data)
    #   defer.resolve(e.data)
    # , false
    
    # return defer.promise
    start = new Date().getTime()
    solutions = []
    positionlog = null
    brick.positions.each (position) =>
      if position.attributes.gate is 'output'
        i = 0
        structureQueue = []
        queue = new PriorityQueue(comparator: (a, b) -> b.comp - a.comp)
        list = Array.apply(null, new Array(101)).map(Number.prototype.valueOf,0);
        # Define structure of simulations 

        structureQueue.push({ position: position.incoming_connections.first().position_from, output: -1  }) # placeholder
        while structureQueue.length > 0
          tempPosition = structureQueue.pop()
          list[i] = tempPosition.output
          if tempPosition.position.attributes.gate is 'and'
            # For every input of brick-and
            queue.queue { position: tempPosition.position, comp: i, output: tempPosition.output }
            tempPosition.position.incoming_connections.each (connection) =>
              structureQueue.push( { position: connection.position_from, comp: i, output: tempPosition.output } )
          # Current brick is of type not
          else if tempPosition.position.attributes.gate is 'not'
            queue.queue( { position: tempPosition.position, comp: i, output: tempPosition.output } )
            structureQueue.push( { position: tempPosition.position.incoming_connections.first().position_from, comp: i, output: tempPosition.output } )
          else 
            queue.queue( { position: tempPosition.position, comp: i, output: tempPosition.output } )
          # If brick is not of type not or and, it is an input and this is where the loop should end
          i += 2
        f = (t, x) =>
          equations = []
          tempQueue = new PriorityQueue(comparator: (a, b) -> b.comp - a.comp)
          startIndex = queue.peek().comp # array index
          while queue.length > 0
            equationPosition = queue.dequeue()
            tempQueue.queue(equationPosition)
            currentPosition = equationPosition.position
            # Check whether array element is defined
            index = startIndex - equationPosition.comp
            x[index] ||= 0
            x[index+1] ||= 0

            # All k variables have to come from predefined gene k variables
            if currentPosition.attributes.gate is 'and'
              input1 = startIndex - list.indexOf(equationPosition.comp)
              input2 = startIndex - list.lastIndexOf(equationPosition.comp)

              currentGene1 = _.filter(Gene.all().collection, (gene) ->
                return currentPosition.incoming_connections.first().attributes.selected is gene.attributes.name)[0]
              currentGene2 = _.filter(Gene.all().collection, (gene) ->
                return currentPosition.incoming_connections.last().attributes.selected is gene.attributes.name)[0]
              currentGate = _.filter(AndPromoter.all().collection, (gate) ->
                return ( (currentPosition.incoming_connections.first().attributes.selected is gate.attributes.tf_1 and currentPosition.incoming_connections.last().attributes.selected is gate.attributes.tf_2) or (currentPosition.incoming_connections.first().attributes.selected is gate.attributes.tf_2 and currentPosition.incoming_connections.last().attributes.selected is gate.attributes.tf_1))  )[0]

              k1 = currentGate.attributes.k_1
              km = currentGate.attributes.k_m
              n = currentGate.attributes.n

              gene1_d1 = currentGene1.attributes.d_1
              gene1_d2 = currentGene1.attributes.d_2
              gene1_k2 = currentGene1.attributes.k_2
              gene2_d1 = currentGene2.attributes.d_1
              gene2_d2 = currentGene2.attributes.d_2
              gene2_k2 = currentGene2.attributes.k_2

              equations.push( ( k1 * (x[input1 + 1] * x[input2 + 1])^n ) / ( km^n + (x[input1 + 1] * x[input2 + 1])^n ) - gene1_d1 * x[index] )
              equations.push( gene2_k2 * x[index] - gene2_d2 * x[index+1] )

            else if currentPosition.attributes.gate is 'not'

              currentGene = _.filter(Gene.all().collection, (gene) ->
                return currentPosition.incoming_connections.first().attributes.selected is gene.attributes.name)[0]
              currentGate = _.filter(NotPromoter.all().collection, (gate) ->
                return currentPosition.incoming_connections.first().attributes.selected is gate.attributes.tf)[0]

              k1 = currentGate.attributes.k_1
              km = currentGate.attributes.k_m
              n = currentGate.attributes.n

              gene1_d1 = currentGene.attributes.d_1
              gene1_d2 = currentGene.attributes.d_2
              gene1_k2 = currentGene.attributes.k_2

              input1 = startIndex - list.indexOf(equationPosition.comp) 
              equations.push( ( k1 * km^n ) / ( km^n + x[input1 + 1]^n ) - gene1_d1 * x[index] )
              equations.push( gene1_k2 * x[index] - gene1_d2 * x[index+1] )

            else if currentPosition.attributes.gate is 'input'

              currentGene = _.filter(Gene.all().collection, (gene) ->
                return currentPosition.outgoing_connections.first().attributes.selected is gene.attributes.name)[0]

              gene1_d1 = currentGene.attributes.d_1
              gene1_d2 = currentGene.attributes.d_2
              gene1_k2 = currentGene.attributes.k_2
              equations.push( 1 - gene1_d1 * x[index] )
              equations.push( gene1_k2 * x[index] - gene1_d2 * x[index+1] )
          queue = tempQueue
          equations
        startValues = Array.apply(null, new Array(brick.connections.size() * 2)).map(Number.prototype.valueOf, 0)
        solutions.push(numeric.dopri(0, 20, startValues, f, 1e-6, 100))
    solutions