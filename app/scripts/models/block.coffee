"use strict"
angular.module("geniusApp").factory "Block", (_) ->
  Block = {}
  type = "block"
  defer = hoodie.defer()

  Block.all = ->
    hoodie.store.findAll(type).done (blocks) ->
      defer.resolve blocks
    defer.promise()

  Block.find = (index) ->
    hoodie.store.find(type, index).done (block) ->
      defer.resolve block
    defer.promise()

  Block.where = (properties) ->
    hoodie.store.findAll(type).done (blocks) ->
      defer.resolve _.where(blocks, properties)
    defer.promise()

  Block.add = (attributes) ->
    hoodie.store.add(type, attributes).done (newBlock) ->
      defer.resolve newBlock
    defer.promise()

  Block.destroy = (index) ->
    hoodie.store.remove(type, index).done (removedObject) ->
      defer.resolve removedObject
    defer.promise()

  Block.size = ->
    hoodie.store.findAll(type).done (blocks) ->
      defer.resolve blocks.length
    defer.promise()

  _.forEach _, (func, name) ->
    Block[name] = ->
      args = Array::slice.call(arguments)
      hoodie.store.findAll(type).done (blocks) ->
        args.unshift blocks
        defer.resolve func(args)
    defer.promise()

  Block
