app = angular.module("geniusApp")

app.factory "simulationService", ($compile, $rootScope, $q) ->

  run: (bricks) ->
    worker = new Worker('/scripts/workers/simulationWorker.js')
    defer = $q.defer()

    worker.postMessage bricks

    worker.addEventListener 'message', (e) ->
      console.log('Worker said: ', e.data)
      defer.resolve(e.data)
    , false
    
    return defer.promise