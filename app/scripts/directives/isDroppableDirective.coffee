app = angular.module("geniusApp")

app.directive "isDroppable", ($compile, $rootScope, dropService) ->
  restrict: "A"
  link: (scope, element, attributes) ->
    options = scope.$eval(attributes.isDroppable) #allow options to be passed in
    element.droppable drop: (event, ui) ->
      if ui.draggable.hasClass("new-project")
        $brick_id = ui.draggable.data('brick_id')
        $par = $('#workspace').parent()
        $pos_top = ui.position.top
        $pos_left = ui.position.left + $par.outerWidth() + $par.position().left

        $oldToNew = {}
        $freeGenes = _.difference $rootScope.genes, $rootScope.usedGenes

        $totalTop = 0
        $totalLeft = 0

        $posWithOffsets = {} 

        Brick.find $brick_id, (brick) ->
          if brick.connections.size() + $rootScope.usedGenes.length <= $rootScope.genes.length

            brick.positions.each (pos) ->
              $totalTop += pos.attributes.top
              $totalLeft += pos.attributes.left

            $totalTop = $totalTop / brick.positions.size()
            $totalLeft = $totalLeft / brick.positions.size()

            brick.positions.each (pos) ->
              $posWithOffsets[pos.attributes.id] = { offsetTop: pos.attributes.top - $totalTop, offsetLeft: pos.attributes.left - $totalLeft }

            brick.positions.each (pos) ->
              $newPos = pos.clone()
              $newPos.set 'brick_id', $rootScope.currentBrick.attributes.id

              $new_top = $pos_top + $posWithOffsets[pos.attributes.id].offsetTop
              if $new_top >= 10
                $newPos.set 'top', $new_top
              else
                $newPos.set 'top', 10

              $new_left = $pos_left + $posWithOffsets[pos.attributes.id].offsetLeft

              if $new_left >= 10
                $newPos.set 'left', $new_left
              else
                $newPos.set 'left', 10
              
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

      else if ui.draggable.hasClass('standard-1-to-2')
          $brick_id = $rootScope.currentBrick.attributes.id
          $par = $('#workspace').parent()
          $pos_top = ui.position.top
          $pos_left = ui.position.left + $par.outerWidth() + $par.position().left
          $freeGenes = _.difference $rootScope.genes, $rootScope.usedGenes
          $pos1 = {}
          $pos2 = {}
          $pos3 = {}

          Brick.find $brick_id, (brick) ->
            if 3 + $rootScope.usedGenes.length <= $rootScope.genes.length
              Position.create { brick_id: $brick_id, gate: 'input', top: $pos_top - 80, left: $pos_left - 300 }, (pos) ->
                $pos1 = pos

              Position.create { brick_id: $brick_id, gate: 'input', top: $pos_top + 80, left: $pos_left - 300 }, (pos) ->
                $pos2 = pos

              Position.create { brick_id: $brick_id, gate: 'not', top: $pos_top - 20, left: $pos_left - 150 }, (pos) ->
                $pos3 = pos
                Connection.create { brick_id: $brick_id, endpoint_index: 0, position_from_id: $pos1.id, position_to_id: pos.id, selected: $freeGenes[0] }

              Position.create { brick_id: $brick_id, gate: 'and', top: $pos_top - 60, left: $pos_left + 200 }, (pos) ->
                Connection.create { brick_id: $brick_id, endpoint_index: 0, position_from_id: $pos1.id, position_to_id: pos.id, selected: $freeGenes[0] }
                Connection.create { brick_id: $brick_id, endpoint_index: 1, position_from_id: $pos2.id, position_to_id: pos.id, selected: $freeGenes[1] }

              Position.create { brick_id: $brick_id, gate: 'and', top: $pos_top + 60, left: $pos_left + 200 }, (pos) ->
                Connection.create { brick_id: $brick_id, endpoint_index: 0, position_from_id: $pos3.id, position_to_id: pos.id, selected: $freeGenes[2] }
                Connection.create { brick_id: $brick_id, endpoint_index: 1, position_from_id: $pos2.id, position_to_id: pos.id, selected: $freeGenes[1] }

              scope.clearWorkspace()
              scope.fillWorkspace()
            else
              scope.flash 'danger', 'The brick that has been added contains too many new genes!'

      else if ui.draggable.hasClass('standard-or')
        $brick_id = $rootScope.currentBrick.attributes.id
        $par = $('#workspace').parent()
        $pos_top = ui.position.top
        $pos_left = ui.position.left + $par.outerWidth() + $par.position().left
        $freeGenes = _.difference $rootScope.genes, $rootScope.usedGenes
        $pos1 = {}
        $pos2 = {}
        $pos3 = {}

        Brick.find $brick_id, (brick) ->
          if 3 + $rootScope.usedGenes.length <= $rootScope.genes.length
            Position.create { brick_id: $brick_id, gate: 'not', top: $pos_top - 60, left: $pos_left - 200 }, (pos) ->
              $pos1 = pos

            Position.create { brick_id: $brick_id, gate: 'not', top: $pos_top + 60, left: $pos_left - 200 }, (pos) ->
              $pos2 = pos

            Position.create { brick_id: $brick_id, gate: 'and', top: $pos_top, left: $pos_left }, (pos) ->
              $pos3 = pos

            Position.create { brick_id: $brick_id, gate: 'not', top: $pos_top , left: $pos_left + 200 }, (pos) ->
              Connection.create { brick_id: $brick_id, endpoint_index: 0, position_from_id: $pos3.id, position_to_id: pos.id, selected: $freeGenes[2] }

            Connection.create { brick_id: $brick_id, endpoint_index: 0, position_from_id: $pos1.id, position_to_id: $pos3.id, selected: $freeGenes[0] }
            Connection.create { brick_id: $brick_id, endpoint_index: 1, position_from_id: $pos2.id, position_to_id: $pos3.id, selected: $freeGenes[1] }

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
