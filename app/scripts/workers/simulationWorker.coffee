addEventListener 'message', (e) =>
  window = self

  importScripts('/scripts/vendor/numeric-1.2.6.min.js', '/scripts/vendor/require.js')
  require [ '/scripts/vendor/priority-queue.js' ], (PriorityQueue) =>
    bricks = e.data

    # placeholder data
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

    for brick in bricks
      if brick.brick_type is 'brick-output'
        f = (t, x) =>
          i = 0
          structureQueue = new PriorityQueue()
          queue = new PriorityQueue(comparator: (a, b) -> b.comp - a.comp)
          list = new Array(101)
          # Define structure of simulations 
          structureQueue.queue { brick: brick.connected, output: -1  } # placeholder

          while structureQueue.length > 0
            tempBrick = structureQueue.dequeue()
            list[i] = tempBrick.output

            if tempBrick.brick.brick_type is 'brick-and'
              # For every input of brick-and
              queue.queue { brick: tempBrick.brick, comp: i, output: tempBrick.output }
              for j in [0..1] by 1
                structureQueue.queue { brick: tempBrick.connected[j], output: i }  # placeholder
            # Current brick is of type not
            else if tempBrick.brick.brick_type is 'brick-not'
              queue.queue { brick: tempBrick.brick, comp: i, output: tempBrick.output }
              structureQueue.queue { brick: tempBrick.connected, output: i } # placeholder
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

            equationBrick = queue.dequeue()
            # Check whether array element is defined
            index = startIndex - equationBrick.comp
            if typeof x[index] is 'undefined'
                x[index] = 0

            if typeof x[index+1] is 'undefined'
                x[index+1] = 0

            # All k variables have to come from predefined gene k variables
            if equationBrick.brick_type is 'brick-and'
              input1 = startIndex - list.indexOf(equationBrick.comp)
              input2 = startIndex - list.lastIndexOf(equationBrick.comp)
              equations.push( ( k1 * (x[input1 + 1] * x[input2 + 1])^n ) / ( Km^n + (x[input1 + 1] * x[input2 + 1])^n ) - gene1_d1 * x[index] )
              equations.push( gene2_k2 * x[index] - gene2_d2 * x[index+1] )

            else if equationBrick.brick_type is 'brick-not'
              input1 = startIndex - list.indexOf(equationBrick.comp) 
              equations.push( ( k1 * Km^n ) / ( Km^n + x[input1 + 1]^n ) - gene1_d1 * x[index] )
              equations.push( gene1_k2 * x[index] - gene1_d2 * x[index+1] )

            else if equationBrick.brick_type is 'brick-input'
              equations.push( Math.random() * 30 ) # placeholder, TF have to come from input
              equations.push( Math.random() * 30 ) # placeholder, TF have to come from input

            console.log equations

          equations

        unless typeof brick.connections is 'undefined'
          # TODO: brick.connections.length * 2 is wrong formula

          startValues = Array.apply(null, new Array(brick.connections.length * 2)).map(Number.prototype.valueOf, 0)

          solution = numeric.dopri(0, 20, startValues, f, 1e-6, 2000)

          postMessage solution