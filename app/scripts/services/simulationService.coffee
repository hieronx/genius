app = angular.module("geniusApp")

# app.factory "simulationService", ($compile, $rootScope, $q) ->
app.factory "simulationService", ($compile, $rootScope) ->
  TF1 = 42
  TF2 = 7
  k1 = 4.7313
  gene1_k2 = 4.6337
  gene1_d1 = 0.0240
  gene1_d2 = 0.8466
  gene2_k2 = 4.6337
  gene2_d1 = 0.0205
  gene2_d2 = 0.8627
  Km = 224.0227
  n = 1

  mRNA = 0
  Protein = 0

  run: (brick) ->
    # worker = new Worker('/scripts/workers/simulationWorker.js')
    # defer = $q.defer()
    
    # worker.postMessage bricks

    # worker.addEventListener 'message', (e) ->
    #   console.log('Worker said: ', e.data)
    #   defer.resolve(e.data)
    # , false
    
    # return defer.promise
    solution = null
    brick.positions.each (position) =>
      if position.attributes.gate is 'output'
        f = (t, x) =>
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
          equations = []
          startIndex = queue.peek().comp # array index
          while queue.length > 0 

            # connectedBrick = Brick.where(filter) ->
            #   item.id is connection.source
            # )[j]

            # filter (brick) ->
            #   brick.id 
            # If current brick is of type and

            equationPosition = queue.dequeue()
            currentPosition = equationPosition.position
            # Check whether array element is defined
            index = startIndex - equationPosition.comp
            x[index] ||= 0
            x[index+1] ||= 0

            # All k variables have to come from predefined gene k variables
            if currentPosition.attributes.gate is 'and'
              input1 = startIndex - list.indexOf(equationPosition.comp)
              input2 = startIndex - list.lastIndexOf(equationPosition.comp)
              equations.push( ( k1 * (x[input1 + 1] * x[input2 + 1])^n ) / ( Km^n + (x[input1 + 1] * x[input2 + 1])^n ) - gene1_d1 * x[index] )
              equations.push( gene2_k2 * x[index] - gene2_d2 * x[index+1] )

            else if currentPosition.attributes.gate is 'not'
              input1 = startIndex - list.indexOf(equationPosition.comp) 
              equations.push( ( k1 * Km^n ) / ( Km^n + x[input1 + 1]^n ) - gene1_d1 * x[index] )
              equations.push( gene1_k2 * x[index] - gene1_d2 * x[index+1] )

            else if currentPosition.attributes.gate is 'input'
              equations.push( TF1 ) # placeholder, TF have to come from input
              equations.push( TF2 ) # placeholder, TF have to come from input

          equations

          # if brick.connections?
            # TODO: brick.connections.length * 2 is wrong formula

        startValues = Array.apply(null, new Array(brick.connections.size() * 2)).map(Number.prototype.valueOf, 0)
        #solution = 
        solution = numeric.dopri(0, 20, startValues, f, 1e-6, 2000)
    solution