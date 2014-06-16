app = angular.module("geniusApp")

app.directive "isDroppable", ($compile, $rootScope, dropService) ->
  restrict: "A"
  link: (scope, element, attributes) ->
    options = scope.$eval(attributes.isDroppable) #allow options to be passed in
    element.droppable drop: (event, ui) ->
      position = $rootScope.currentBrick.positions.new()

      if ui.draggable.hasClass 'canvas-element'
        pid = ui.draggable.attr 'id'
        Position.find pid, (position) =>
          dropService.drop(position, scope, ui, false)

      else
        $canvas = $(this)
        $par = $canvas.parent()

        if ui.draggable.hasClass("and")
          position.set 'gate', 'and'

        else if ui.draggable.hasClass("not")
          position.set 'gate', 'not'

        else if ui.draggable.hasClass("input")
          position.set 'gate', 'input'

        else if ui.draggable.hasClass("output")
          position.set 'gate', 'output'

        position.save ->
          dropService.drop(position, scope, ui, true)
