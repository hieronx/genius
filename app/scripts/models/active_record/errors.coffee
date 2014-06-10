
class ActiveRecord.Errors

  constructor: (@model) ->
    @errors = {}

  add: (attribute, message) ->
    @errors[attribute] = []  unless @errors[attribute]
    @errors[attribute].push message
    @

  all: ->
    @errors

  clear: ->
    @errors = {}
    @

  each: (func) ->
    for attribute of @errors
      i = 0

      while i < @errors[attribute].length
        func.call @, attribute, @errors[attribute][i]
        i++
    @

  on: (attribute) ->
    @errors[attribute] or []

  size: ->
    count = 0
    @each ->
      count++
    count
