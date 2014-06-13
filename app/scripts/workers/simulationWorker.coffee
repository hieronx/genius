addEventListener 'message', (e) =>
  importScripts('/scripts/vendor/numeric-1.2.6.min.js')

  bricks = e.data

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
      console.log brick.connections
      f = (t, x) ->
        i = 0
        equations = []
        addEquations = (brick) ->  
          # connectedBrick = Brick.where(filter) ->
          #   item.id is connection.source
          # )[j]
          filter (brick) ->
            brick.id 
          # If current brick is of type and
          if brick.brick_type is 'brick-and'
            # For every input of brick-and
            for i in [0..1] by 1 
          # Current brick is of type not
          else if brick.brick_type is 'brick-output'
            addEquations(connectedBrick)
          else
            # Connected brick is of type brick-input
            if connectedBrick.brick_type is 'brick-input'
              # Input is transcription factor of brick-input
              input = TF1
              equations.push( ( k1 * Km^n ) / ( Km^n + input^n ) - gene1_d1 * x[i] )
              equations.push( gene1_k2 * x[i] - gene1_d2 * x[i+1] )
            # Connected brick is of type brick-not
            else if connectedBrick.brick_type is 'brick-not'
              temp = i
              i += 2
              x[i] = 0
              x[i + 1] = 0 
              addEquations(connectedBrick)
              input = x[temp + 3]
              equations.push( ( k1 * Km^n ) / ( Km^n + input^n ) - gene1_d1 * x[temp] )
              equations.push( gene1_k2 * x[temp] - gene1_d2 * x[temp + 1] )

            else if connectedBrick.brick_type is 'brick-and'
              temp = i
              i += 2
              x[i] = 0
              x[i + 1] = 0 
              addEquations(connectedBrick)
              temp2 = i
              i += 2
              x[i] = 0
              x[i + 1] = 0 
              addEquations(connectedBrick)
              input2 = x[temp + 3]
              equations.push( ( k1 * (TF1 * TF2)^n ) / ( Km^n + (TF1 * TF2)^n ) - gene1_d1 * x[i] )
              equations.push( gene2_k2 * x[i] - gene2_d2 * x[i+1] )

            j += 1
            i += 2
            if typeof x[i] is 'undefined'
              x[i] = 0

            if typeof x[i+1] is 'undefined'
              x[i+1] = 0

        addEquations(brick)
        console.log equations
        equations

      unless typeof brick.connections is 'undefined'
        # TODO: brick.connections.length * 2 is wrong formula

        startValues = Array.apply(null, new Array(brick.connections.length * 2)).map(Number.prototype.valueOf,0)

        solution = numeric.dopri(0, 20, startValues, f, 1e-6, 2000)

        postMessage solution