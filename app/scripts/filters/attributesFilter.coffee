app = angular.module('geniusApp')

app.filter 'attributes', ->
  (models) ->
    _.map models, (model) -> model.attributes
