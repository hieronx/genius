"use strict"
angular.module("geniusApp").factory "Brick", (_) ->
  Brick = {}
  type = "brick"
  defer = hoodie.defer()

  Brick.all = ->
    hoodie.store.findAll(type).done (bricks) ->
      defer.resolve bricks
    defer.promise()

  Brick.find = (index) ->
    hoodie.store.find(type, index).done (brick) ->
      defer.resolve brick
    defer.promise()

  Brick.where = (properties) ->
    hoodie.store.findAll(type).done (bricks) ->
      defer.resolve _.where(bricks, properties)
    defer.promise()

  Brick.add = (attributes) ->
    hoodie.store.add(type, attributes).done (newBrick) ->
      defer.resolve newBrick
    defer.promise()

  Brick.destroy = (index) ->
    hoodie.store.remove(type, index).done (removedObject) ->
      defer.resolve removedObject
    defer.promise()

  Brick.size = ->
    hoodie.store.findAll(type).done (bricks) ->
      defer.resolve bricks.length
    defer.promise()

  _.forEach _, (func, name) ->
    Brick[name] = ->
      args = Array::slice.call(arguments)
      hoodie.store.findAll(type).done (bricks) ->
        args.unshift bricks
        defer.resolve func(args)
    defer.promise()

  Brick