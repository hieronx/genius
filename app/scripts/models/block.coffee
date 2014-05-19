"use strict"
angular.module("geniusApp").factory "Block", (_) ->
  Block = {}
  type = "block"
  defer = hoodie.defer()
  Block.all = ->
    hoodie.store.findAll(type).done (blocks) ->
      defer.resolve blocks
      return

    defer.promise()

  Block.find = (index) ->
    hoodie.store.find(type, index).done (block) ->
      defer.resolve block
      return

    defer.promise()

  Block.where = (properties) ->
    hoodie.store.findAll(type).done (blocks) ->
      defer.resolve _.where(blocks, properties)
      return

    defer.promise()

  Block.add = (attributes) ->
    hoodie.store.add(type, attributes).done (newBlock) ->
      defer.resolve newBlock
      return

    defer.promise()

  Block.destroy = (index) ->
    hoodie.store.remove(type, index).done (removedObject) ->
      defer.resolve removedObject
      return

    defer.promise()

  Block.size = ->
    hoodie.store.findAll(type).done (blocks) ->
      defer.resolve blocks.length
      return

    defer.promise()

  _.forEach _, (func, name) ->
    Block[name] = ->
      args = Array::slice.call(arguments_, 0)
      hoodie.store.findAll(type).done (blocks) ->
        args.unshift blocks
        defer.resolve func(args)
        return

      return

    defer.promise()

  Block
