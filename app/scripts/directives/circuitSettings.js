'use strict'

angular.module('geniusApp').directive('circuitSettings', function($rootScope) {
  return {
    restrict: 'A',
    link: function(scope, element, attributes) {
      var options = scope.$eval(attributes.isDraggable); //allow options to be passed in
      jsPlumb.Defaults.Container = element;

      // the definition of source endpoints (the small blue ones)
      $rootScope.sourceEndpoint = {
        endpoint:"Dot",
        paintStyle:{ 
          strokeStyle:"#7AB02C",
          fillStyle:"transparent",
          radius:7,
          lineWidth:3 
        },        
        isSource:true,
        isTarget:true,
        connector:[ "Flowchart", { stub:[40, 60], gap:10, cornerRadius:5, alwaysRespectStubs:true } ],                                
        connectorStyle: { lineWidth:4, strokeStyle:"#61B7CF", joinstyle:"round", outlineColor:"transparent" },
        hoverPaintStyle: { fillStyle:"#216477", strokeStyle:"#216477" },
        connectorHoverStyle: { lineWidth:4, strokeStyle:"#216477", outlineColor:"transparent" }
      };

      $rootScope.targetEndpoint = {
        endpoint:"Dot",         
        paintStyle:{ fillStyle:"#7AB02C",radius:11 },
        maxConnections: -1,
        connector:[ "Flowchart", { stub:[40, 60], gap:10, cornerRadius:5, alwaysRespectStubs:true } ],                                
        connectorStyle: { lineWidth:4, strokeStyle:"#61B7CF", joinstyle:"round", outlineColor:"transparent" },
        hoverPaintStyle: { fillStyle:"#216477", strokeStyle:"#216477" },
        connectorHoverStyle: { lineWidth:4, strokeStyle:"#216477", outlineColor:"transparent" },
        isSource:true,
        isTarget:true  
      };
    }
  };
});