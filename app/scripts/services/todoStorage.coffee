#global todomvc
"use strict"

###
Services that persists and retrieves TODOs from localStorage
###
angular.module("geniusApp").factory "todoStorage", ->
  STORAGE_ID = "todos-angularjs"

  get: ->
    deferred = $.Deferred()
    hoodie.store.findOrAdd("todo", STORAGE_ID,
      values: []
    ).then (loaded) ->
      deferred.resolve loaded.values

    deferred.promise()

  put: (todos) ->
    hoodie.store.update "todo", STORAGE_ID,
      values: todos
