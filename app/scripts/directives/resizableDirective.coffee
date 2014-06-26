app = angular.module("geniusApp")

app.directive "resizable", ->
  restrict: "A"

  scope:
    callback: "&onResize"

  link: (scope, elem, attrs) ->
    elem.resizable
      handles: "w"
    elem.on "resizestop", (evt, ui) ->
      scope.callback?()
