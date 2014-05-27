app = angular.module("geniusApp")

app.directive "isDroppable", (Brick, $compile, $rootScope, dropService) ->
  restrict: "A"
  link: (scope, element, attributes) ->
    options = scope.$eval(attributes.isDroppable) #allow options to be passed in
    element.droppable drop: (event, ui) ->
      $canvas = $(this)
      $par = $canvas.parent()

      brick =
        type: 'gate-and'

      Brick.add(brick).done (newBrick) ->
        console.log newBrick
        dropService.drop(newBrick.id, scope, ui, true)
