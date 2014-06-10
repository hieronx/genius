app = angular.module("geniusApp")

app.directive "isDroppable", ($compile, $rootScope, dropService) ->
  restrict: "A"
  link: (scope, element, attributes) ->
    options = scope.$eval(attributes.isDroppable) #allow options to be passed in
    element.droppable drop: (event, ui) ->
      brick = new Brick()

      if ui.draggable.hasClass 'canvas-element'
        $canid = ui.draggable.attr 'id'
        index = $canid.slice 6

        dropService.drop(index, scope, ui, false)

      else
        $canvas = $(this)
        $par = $canvas.parent()

        if ui.draggable.hasClass("brick-and")
          brick.set 'brick_type', 'brick-and'

        else if ui.draggable.hasClass("brick-not")
          brick.set 'brick_type', 'brick-not'

        else if ui.draggable.hasClass("brick-input")
          brick.set 'brick_type', 'brick-input'

        else if ui.draggable.hasClass("brick-output")
          brick.set 'brick_type', 'brick-output'

        brick.save ->
          dropService.drop(brick, scope, ui, true)
