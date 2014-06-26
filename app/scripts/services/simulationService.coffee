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
    genes = {}
    Gene.each (gene) ->
      genes[gene.get('name')] = gene

    notGates = {}
    NotPromoter.each (gate) ->
      notGates[gate.get('tf')] = gate

    andGates = {}
    AndPromoter.each (gate) ->
      andGates[gate.get('tf_1') + gate.get('tf_2')] = gate

    solutions = []
    brick.positions.each (position) =>
      if position.get('gate') is 'output'
        i = 0
        structureQueue = []
        queue = new PriorityQueue(comparator: (a, b) -> b.comp - a.comp)
        list = Array.apply(null, new Array(101)).map(Number.prototype.valueOf,0);
        # Define structure of simulations

        structureQueue.push({ position: position.incoming_connections.first().position_from, output: -1  }) # placeholder
        while structureQueue.length > 0
          tempPosition = structureQueue.pop()
          list[i] = tempPosition.output

          if tempPosition.position.get('gate') is 'and'
            # For every input of brick-and
            queue.queue { position: tempPosition.position, comp: i, output: tempPosition.output }
            tempPosition.position.incoming_connections.each (connection) =>
              structureQueue.push( { position: connection.position_from, comp: i, output: tempPosition.output } )

          # Current brick is of type not
          else if tempPosition.position.get('gate') is 'not'
            queue.queue( { position: tempPosition.position, comp: i, output: tempPosition.output } )
            structureQueue.push( { position: tempPosition.position.incoming_connections.first().position_from, comp: i, output: tempPosition.output } )
          else
            queue.queue( { position: tempPosition.position, comp: i, output: tempPosition.output, g: 0 } )

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
            if currentPosition.get('gate') is 'and'
              tempQueue.queue(equationPosition)
              input1 = startIndex - list.indexOf(equationPosition.comp)
              input2 = startIndex - list.lastIndexOf(equationPosition.comp)

              currentGene1 = genes[currentPosition.incoming_connections.first().get('selected')]
              currentGene2 = genes[currentPosition.incoming_connections.last().get('selected')]
              currentGate = andGates[currentPosition.incoming_connections.first().get('selected') + currentPosition.incoming_connections.last().get('selected')] || andGates[currentPosition.incoming_connections.last().get('selected') + currentPosition.incoming_connections.first().get('selected')]

              k1 = currentGate.get('k_1')
              km = currentGate.get('k_m')
              n = currentGate.get('n')

              gene1_d1 = currentGene1.get('d_1')
              gene1_d2 = currentGene1.get('d_2')
              gene1_k2 = currentGene1.get('k_2')
              gene2_d1 = currentGene2.get('d_1')
              gene2_d2 = currentGene2.get('d_2')
              gene2_k2 = currentGene2.get('k_2')

              equations.push( ( k1 * (x[input1 + 1] * x[input2 + 1])^n ) / ( km^n + (x[input1 + 1] * x[input2 + 1])^n ) - gene1_d1 * x[index] )
              equations.push( gene2_k2 * x[index] - gene2_d2 * x[index+1] )

            else if currentPosition.get('gate') is 'not'
              tempQueue.queue(equationPosition)
              currentGene = genes[currentPosition.incoming_connections.first().get('selected')]
              currentGate = notGates[currentPosition.incoming_connections.first().get('selected')]

              k1 = currentGate.get('k_1')
              km = currentGate.get('k_m')
              n = currentGate.get('n')

              gene1_d1 = currentGene.get('d_1')
              gene1_d2 = currentGene.get('d_2')
              gene1_k2 = currentGene.get('k_2')

              input1 = startIndex - list.indexOf(equationPosition.comp)
              equations.push( ( k1 * km^n ) / ( km^n + x[input1 + 1]^n ) - gene1_d1 * x[index] )
              equations.push( gene1_k2 * x[index] - gene1_d2 * x[index+1] )

            else if currentPosition.get('gate') is 'input'

              currentGene = genes[currentPosition.outgoing_connections.first().get('selected')]
              input = 1
              g = equationPosition.g
              if currentPosition.get('input_signal')?
                input = currentPosition.get('input_signal')
                if g >= 0 and g < 60
                  input = input[0]
                else if g >= 60 and g < 120
                  input = input[1]
                else if g >= 120 and g < 180
                  input = input[2]
                else if g >= 180 and g < 240
                  input = input[3]
                else
                  input = input[4]
              g += 1
              gene1_d1 = currentGene.get('d_1')
              gene1_d2 = currentGene.get('d_2')
              gene1_k2 = currentGene.get('k_2')
              equationPosition.g += 1
              tempQueue.queue(equationPosition)
              equations.push( input - gene1_d1 * x[index] )
              equations.push( gene1_k2 * x[index] - gene1_d2 * x[index+1] )
          queue = tempQueue
          equations
        startValues = Array.apply(null, new Array(brick.connections.size() * 5)).map(Number.prototype.valueOf, 0)
        solutions.push(numeric.dopri(0, 20, startValues, f, 1e-6, 50))
    solutions