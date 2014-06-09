app = angular.module("geniusApp")

app.factory "simulationService", ($compile, $rootScope) ->

  TF1 = 42
  TF2 = 7
  k1 = 4.7313
  k2 = 4.6337
  d1 = 0.0240
  d2 = 0.8466
  Km = 224.0227
  n = 1

  mRNA = 0
  Protein = 0

  run: (bricks) ->
    for brick in bricks
      if brick.brick_type is 'brick-input'

        f = (t, x) ->
          i = 0

          equations = []

          addEquations = (connections) ->
            unless typeof connections is 'undefined'
              for connection in connections
                connectedBrick = bricks.filter((item) ->
                  item.id is connection.target
                )[0]

                if connectedBrick.brick_type is 'brick-not'
                  if i is 0
                    equations.push( ( k1 * Km^n ) / ( Km^n + TF1^n ) - d1 * x[i] )
                    equations.push( k2 * x[i] - d2 * x[i+1] )

                  else if x[i-1] is 0
                    x[i] = 0
                    x[i+1] = 0
                    
                    equations.push( ( k1 * Km^n ) / ( Km^n ) - d1 * x[i] )
                    equations.push( k2 * x[i] - d2 * x[i+1] )

                  else
                    equations.push( ( k1 * Km^n ) / ( Km^n + x[i-1]^n ) - d1 * x[i] )
                    equations.push( k2 * x[i] - d2 * x[i+1] )

                i += 2

                addEquations(connectedBrick.connections)

          addEquations(brick.connections)

          equations

        unless brick.connections is 'undefined'
          # TODO: brick.connections.length * 2 is wrong formula
          startValues = Array.apply(null, new Array(brick.connections.length * 2)).map(Number.prototype.valueOf,0)

          sol = numeric.dopri(0, 20, startValues, f, 1e-6, 2000)

          return sol