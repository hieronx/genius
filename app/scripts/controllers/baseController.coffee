
class @BaseCtrl

  @register: ->
    @name ||= @toString().match(/function\s*(.*?)\(/)?[1]
    app = angular.module("geniusApp")
    app.controller @name, @

  @inject: (annotations...) ->
    ANNOTATION_REG = /^(\S+)(\s+as\s+(\w+))?$/

    @annotations = _.map annotations, (annotation) ->
      match = annotation.match(ANNOTATION_REG)
      name: match[1], identifier: match[3] or match[1]

    @$inject = _.map @annotations, (annotation) -> annotation.name

  constructor: (dependencies...) ->
    for annotation, index in @constructor.annotations
      @[annotation.identifier] = dependencies[index]

    @initialize?()
