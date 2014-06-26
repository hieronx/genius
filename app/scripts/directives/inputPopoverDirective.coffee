app = angular.module("geniusApp")

app.directive "inputPopover", ($compile, $rootScope) ->
  restrict: 'A'
  link: (scope, element, attributes) ->
    options = scope.$eval(attributes.inputPopover)

    scope.inputChart =
      width: 300
      height: 150
      title:
        text: 'Input signal over time'
      xAxiw:
        title:
          text: 'Time (seconds)'
      yAxis:
        title:
          text: 'Input signal (0 or 1)'

    pid = $(element).attr('id')
    Position.find pid, (position) =>
      input = $('<div><div ng-include="\'views/bricks/input.html\'"></div></div>')

      element.popover(
        trigger:'click'
        html : true
        placement: 'bottom'
        content: input
      )

      $compile(input)($rootScope)
