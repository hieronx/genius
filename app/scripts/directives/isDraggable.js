'use strict'

angular.module('geniusApp').directive('isDraggable', function() {
  return {
    restrict: 'A',
    link: function(scope, element, attributes) {
      var options = scope.$eval(attributes.isDraggable); //allow options to be passed in
      element.draggable(options);
    }
  };
});