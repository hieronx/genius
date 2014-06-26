app = angular.module("geniusApp")

app.directive "isDroppable", ($compile, $rootScope, dropService) ->
  restrict: "A"
  link: (scope, element, attributes) ->
    options = scope.$eval(attributes.isDroppable) #allow options to be passed in
    element.droppable drop: (event, ui) ->
      if ui.draggable.hasClass("new-project")
        $brick_id = ui.draggable.data('brick_id')
        $oldToNew = {}
        $freeGenes = _.difference $rootScope.genes, $rootScope.usedGenes

        Brick.find $brick_id, (brick) ->
          if brick.connections.size() + $rootScope.usedGenes.length <= $rootScope.genes.length
            brick.positions.each (pos) ->
              $newPos = pos.clone()
              $newPos.set 'brick_id', $rootScope.currentBrick.attributes.id
              
              $newPos.save ->
                $oldToNew[$newPos.attributes.id] = pos.attributes.id

            brick.connections.each (conn) ->
              $newConn = conn.clone()
              $newConn.set 'brick_id', $rootScope.currentBrick.attributes.id
              $newConn.set 'position_from_id', (_.invert($oldToNew))[conn.attributes.position_from_id]
              $newConn.set 'position_to_id', (_.invert($oldToNew))[conn.attributes.position_to_id]
              $newConn.set 'selected', $freeGenes[0]
              $freeGenes.shift()

              $newConn.save()
              
            scope.clearWorkspace()
            scope.fillWorkspace()
          else
            scope.flash 'danger', 'The brick that has been added contains too many new genes!'

      else
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
