'use strict'

angular.module('geniusApp').directive('isDroppable', function() {
  return {
    restrict: 'A',
    link: function(scope, element, attributes) {
      var options = scope.$eval(attributes.isDraggable); //allow options to be passed in
      var index = 1;
      element.droppable({
        drop: function (event, ui) {

          var $canvas = $(this);

          if (!ui.draggable.hasClass('canvas-element')) {
            var $canvasElement = ui.draggable.clone();
            $canvasElement.addClass('canvas-element');
            $canvasElement.draggable({
              containment: '#workspace'
            });
            $canvasElement.addClass('brick-jsplumb').attr('id', 'brick-' + index);
            index++;
            $canvas.append($canvasElement);

            var $par = $canvas.parent();
            $canvasElement.css({
              left: (ui.position.left + $par.outerWidth() + $par.position().left + 'px'),
              top: (ui.position.top),
              position: 'absolute'
            });
            $canvasElement.draggable( "destroy" );

            jsPlumb.addEndpoint($canvasElement.attr('id'), { anchor:[0, 0.2, -1, 0] }, scope.sourceEndpoint);
            jsPlumb.addEndpoint($canvasElement.attr('id'), { anchor:[0, 0.8, -1, 0] }, scope.sourceEndpoint);
            jsPlumb.addEndpoint($canvasElement.attr('id'), { anchor:[1, 0.5, 0, 0] }, scope.targetEndpoint);  

            jsPlumb.draggable($canvasElement);
          }
        }
      });
    }
  };
});