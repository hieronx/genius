app = angular.module("geniusApp")

app.directive "inputPopover", ($compile, $rootScope) ->
  restrict: 'A'
  link: (scope, element, attributes) ->
    options = scope.$eval(attributes.inputPopover)

    scope.inputChart =
      options:
        chart:
          animation: false
          margin: 25
        legend:
          enabled: false
        tooltip:
          enabled: false
      size:
        width: 350
        height: 200
      title:
        text: ''
      xAxis:
        text: ''
        allowDecimals: false
      yAxis:
        title:
          text: ''
        currentMin: 0
        currentMax: 1
        allowDecimals: false
      series: [{
        data: [0, 1, 1, 0, 1]
        draggableY: true
        dragMinY: 0
        dragMaxY: 1
      }]

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
