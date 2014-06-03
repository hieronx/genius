app = angular.module("geniusApp")

app.factory "simulationService", ($compile, $rootScope, Brick) ->

  k = [3, 1, 3]

  S = 10
  E = 7
  C = 0
  P = 0

  run: (bricks) ->
    f = (t, x) ->
      [
        - k[0] * x[1] * x[0] + k[1] * x[2]
        - k[0] * x[1] * x[0] + k[1] * x[2] + k[2] * x[2]
        k[0] * x[1] * x[0] - k[1] * x[2] - k[2] * x[2]
        k[2] * x[2]
      ]

    sol = numeric.dopri(0, 20, [
      S
      E
      C
      P
    ], f, 1e-6, 2000)

    return sol