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
                  drop: ->
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

      element.popover
        trigger: 'click'
        html : true
        placement: 'bottom'
        content: $('<div style="width: 350px; height: 200px;"></div>')
      element.on 'show.bs.popover', =>
        element.next().find('.popover-content').empty()
      element.on 'shown.bs.popover', =>
        element.next().find('.popover-content').empty()
        input = $('<highchart config="inputChart"></highchart>')
        $compile(input)(scope)
        element.next().find('.popover-content').append input
        $("#and").mouseover()
                 .mouseout()
