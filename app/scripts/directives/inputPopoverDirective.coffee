app = angular.module("geniusApp")

app.directive "inputPopover", ($compile, $rootScope) ->
  restrict: 'A'
  scope: {}
  link: (scope, element, attributes) ->
    options = scope.$eval(attributes.inputPopover)

    pid = $(element).attr('id')
    Position.find pid, (position) =>
      input = $('<highchart config="inputChart"></highchart>')

      scope.inputChart =
        options:
          chart:
            animation: false
            margin: 25
          legend:
            enabled: false
          tooltip:
            enabled: false
          plotOptions:
            series:
              point:
                events:
                  drop: (e) ->
                    signal = _.map @series.data, (p) -> Math.round(p.y)
                    position.set 'input_signal', signal
                    position.save()
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
          data: position.get('input_signal') || [1, 1, 1, 1, 1]
          draggableY: true
          dragMinY: 0
          dragMaxY: 1
        }]
        credits:
          enabled: false
        func: (chart) -> console.log chart

      element.popover
        trigger: 'click'
        html : true
        placement: 'bottom'
        content: input

      $compile(input)(scope)

      setTimeout (=>
        $("#and").mouseover()
                 .mouseout()
      ), 0
