'use strict'

var App = angular.module('geniusApp', []);

App.directive('isDraggable', function() {
  return {
    restrict: 'A',
    link: function(scope, elm, attrs) {
      var options = scope.$eval(attrs.isDraggable); //allow options to be passed in
      elm.draggable(options);
    }
  };
});
