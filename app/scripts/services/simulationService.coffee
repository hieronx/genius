app = angular.module("geniusApp")

app.factory "simulationService", ($compile, $rootScope, Brick) ->

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
    worker = new Worker('/scripts/workers/simulationWorker.js')
    defer = $q.defer()
    
    worker.postMessage bricks

    worker.addEventListener 'message', (e) ->
      console.log('Worker said: ', e.data)
      defer.resolve(e.data)
    , false
    
    return defer.promise
