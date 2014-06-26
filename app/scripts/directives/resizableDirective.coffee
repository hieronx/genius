app = angular.module("geniusApp")

app.directive "resizable", ->
  restrict: "A"

  scope:
    callback: "&onResize"

  link: (scope, elem, attrs) ->
    scope.windowWidth = $(window).width()

    $(window).resize =>
      elem.prev().width elem.prev().width() + ($(window).width() - scope.windowWidth)
      scope.windowWidth = $(window).width()

      elem.resizable "option",
        maxWidth: scope.windowWidth - 79

    elem.resizable
      handles: "w"
      minWidth: 252
      maxWidth: scope.windowWidth - 79
      resize: =>
        elem.prev().width scope.windowWidth - elem.width()

    elem.on "resizestop", (evt, ui) ->
      scope.callback?()
