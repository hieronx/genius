app = angular.module("geniusApp")

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

  run: (bricks) ->
    for brick in bricks
      if brick.brick_type is 'brick-output'

        f = (t, x) ->
          i = 0
          equations = []

          # Version input first
          # addEquations = (connections) ->

          #   unless typeof connections is 'undefined'
          #     for connection in connections
          #       connectedBrick = bricks.filter((item) ->
          #         item.id is connection.target
          #       )[0]

          #       if i is 0
          #         input = TF1
          #       else if typeof x[i-1] is 'undefined'
          #         input = 0
          #       else
          #         input = x[i-1]

          #       if typeof x[i] is 'undefined'
          #         x[i] = 0

          #       if typeof x[i+1] is 'undefined'
          #         x[i+1] = 0

          #       if connectedBrick.brick_type is 'brick-not'
          #           equations.push( ( k1 * Km^n ) / ( Km^n + input^n ) - gene1_d1 * x[i] )
          #           equations.push( gene1_k2 * x[i] - gene1_d2 * x[i+1] )

          #       else if connectedBrick.brick_type is 'brick-and'
          #         if i is 0
          #           equations.push( ( k1 * (TF1 * TF2)^n ) / ( Km^n + (TF1 * TF2)^n ) - gene1_d1 * x[i] )
          #           equations.push( gene2_k2 * x[i] - gene2_d2 * x[i+1] )

          #         else if x[i-1] is 0
          #           x[i] = 0
          #           x[i+1] = 0
                    
          #           equations.push( ( k1 * (TF1 * TF2)^n ) / ( Km^n + (TF1 * TF2)^n ) - gene1_d1 * x[i] )
          #           equations.push( gene2_k2 * x[i-1] - gene2_d2 * x[i+1] )

          #         else
          #           # Todo
          #           equations.push( ( k1 * Km^n ) / ( Km^n + x[i-1]^n ) - gene2_d1 * x[i] )
          #           equations.push( gene2_k2 * x[i] - gene2_d2 * x[i+1] )

          #       i += 2

          #       addEquations(connectedBrick.connections)
          addEquations = (brick, connections) ->
            unless typeof connections is 'undefined'
              for connection in connections 
                j = 0
                connectedBrick = bricks.filter((item) ->
                  item.id is connection.source
                )[0]

                # if i is 0
                #   input = TF1

                if connectedBrick.brick_type is 'brick-input'
                  input = TF1
                  if brick.brick_type is 'brick-not'
                    if typeof x[i-1] is 'undefined'
                      input = 0
                    else
                      input = x[i-1]
                    equations.push( ( k1 * Km^n ) / ( Km^n + input^n ) - gene1_d1 * x[i] )
                    equations.push( gene1_k2 * x[i] - gene1_d2 * x[i+1] )

                else if connectedBrick.brick_type is 'brick-not'
                  addEquations(connectedBrick, connectedBrick.connections)
                  if typeof x[i-1] is 'undefined'
                    input = 0
                  else
                    input = x[i-1]
                  equations.push( ( k1 * Km^n ) / ( Km^n + input^n ) - gene1_d1 * x[i] )
                  equations.push( gene1_k2 * x[i] - gene1_d2 * x[i+1] )



                # else if connectedBrick.brick_type is 'brick-and'
                #   if i is 0
                #     equations.push( ( k1 * (TF1 * TF2)^n ) / ( Km^n + (TF1 * TF2)^n ) - gene1_d1 * x[i] )
                #     equations.push( gene2_k2 * x[i] - gene2_d2 * x[i+1] )

                #   else if x[i-1] is 0
                #     x[i] = 0
                #     x[i+1] = 0
                    
                #     equations.push( ( k1 * (TF1 * TF2)^n ) / ( Km^n + (TF1 * TF2)^n ) - gene1_d1 * x[i] )
                #     equations.push( gene2_k2 * x[i-1] - gene2_d2 * x[i+1] )

                #   else
                #     # Todo
                #     equations.push( ( k1 * Km^n ) / ( Km^n + x[i-1]^n ) - gene2_d1 * x[i] )
                #     equations.push( gene2_k2 * x[i] - gene2_d2 * x[i+1] )
                #j += 1
                i += 2
                if typeof x[i] is 'undefined'
                  x[i] = 0

                if typeof x[i+1] is 'undefined'
                  x[i+1] = 0
                  
          addEquations(brick, brick.connections)
          console.log equations
          equations

        unless brick.connections is 'undefined'
          # TODO: brick.connections.length * 2 is wrong formula
          startValues = Array.apply(null, new Array(brick.connections.length * 2)).map(Number.prototype.valueOf,0)

          sol = numeric.dopri(0, 20, startValues, f, 1e-6, 2000)

          return sol