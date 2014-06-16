app = angular.module("geniusApp")

app.directive "isDroppable", ($compile, $rootScope, dropService) ->
  restrict: "A"
  link: (scope, element, attributes) ->
    options = scope.$eval(attributes.isDroppable) #allow options to be passed in
    element.droppable drop: (event, ui) ->
      position = $rootScope.currentBrick.positions.new()

      if ui.draggable.hasClass 'canvas-element'
        $canid = ui.draggable.attr 'id'
        index = $canid.slice 6

        dropService.drop(index, scope, ui, false)

      else
        $canvas = $(this)
        $par = $canvas.parent()

        if ui.draggable.hasClass("brick-and")
          position.set 'gate_type', 'brick-and'

        else if ui.draggable.hasClass("brick-not")
          position.set 'gate_type', 'brick-not'

        else if ui.draggable.hasClass("brick-input")
          position.set 'gate_type', 'brick-input'

        else if ui.draggable.hasClass("brick-output")
          position.set 'gate_type', 'brick-output'

        position.save ->
          dropService.drop(position, scope, ui, true)
