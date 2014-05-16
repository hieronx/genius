/*global todomvc */
'use strict';

/**
 * The main controller for the app. The controller:
 * - retrieves and persists the model via the todoStorage service
 * - exposes the model to the template and provides event handlers
 */
angular.module('geniusApp').controller('MainCtrl', function TodoCtrl($scope, $location, todoStorage, filterFilter) {
  var todos

  var promise = todoStorage.get();
  promise.done(function(loaded) {
    todos = $scope.todos = loaded;
  });
  
  $scope.newTodo = '';
  $scope.editedTodo = null;

  $scope.$watch('todos', function () {
    $scope.remainingCount = filterFilter(todos, { completed: false }).length;
    $scope.completedCount = todos.length - $scope.remainingCount;
    $scope.allChecked = !$scope.remainingCount;
    todoStorage.put(todos);
  }, true);

  if ($location.path() === '') {
    $location.path('/');
  }

  $scope.location = $location;

  $scope.$watch('location.path()', function (path) {
    $scope.statusFilter = (path === '/active') ?
      { completed: false } : (path === '/completed') ?
      { completed: true } : null;
  });

  $scope.addTodo = function () {
    var newTodo = $scope.newTodo.trim();
    if (!newTodo.length) {
      return;
    }

    todos.push({
      title: newTodo,
      completed: false
    });

    $scope.newTodo = '';
  };

  $scope.editTodo = function (todo) {
    $scope.editedTodo = todo;
  };

  $scope.doneEditing = function (todo) {
    $scope.editedTodo = null;
    todo.title = todo.title.trim();

    if (!todo.title) {
      $scope.removeTodo(todo);
    }
  };

  $scope.removeTodo = function (todo) {
    todos.splice(todos.indexOf(todo), 1);
  };

  $scope.clearCompletedTodos = function () {
    $scope.todos = todos = todos.filter(function (val) {
      return !val.completed;
    });
  };

  $scope.markAll = function (completed) {
    todos.forEach(function (todo) {
      todo.completed = completed;
    });
  };
});

angular.module('geniusApp').directive('isDraggable', function() {
  return {
    restrict: 'A',
    link: function(scope, elm, attrs) {
      var options = scope.$eval(attrs.isDraggable); //allow options to be passed in
      elm.draggable(options);
    }
  };
});

angular.module('geniusApp').directive('isDroppable', function() {
  return {
    restrict: 'A',
    link: function(scope, elm, attrs) {
      var options = scope.$eval(attrs.isDraggable); //allow options to be passed in
      var index = 1;
      elm.droppable({
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

            jsPlumb.addEndpoint($canvasElement.attr('id'), { anchor:[0, 0.2, -1, 0] }, sourceEndpoint);
            jsPlumb.addEndpoint($canvasElement.attr('id'), { anchor:[0, 0.8, -1, 0] }, sourceEndpoint);
            jsPlumb.addEndpoint($canvasElement.attr('id'), { anchor:[1, 0.5, 0, 0] }, targetEndpoint);  

            jsPlumb.draggable($canvasElement);
          }
        }
      });
    }
  };
});

angular.module('geniusApp').directive('circuitSettings', function() {
  return {
    restrict: 'A',
    link: function(scope, elm, attrs) {
      var options = scope.$eval(attrs.isDraggable); //allow options to be passed in
      jsPlumb.Defaults.Container = $('#workspace');
  
      connectorPaintStyle = {
        lineWidth:4,
        strokeStyle:"#61B7CF",
        joinstyle:"round",
        outlineColor:"transparent"
      };

      // .. and this is the hover style. 
      connectorHoverStyle = {
        lineWidth:4,
        strokeStyle:"#216477",
        outlineColor:"transparent"
      };

      endpointHoverStyle = {
        fillStyle:"#216477",
        strokeStyle:"#216477"
      };

      // the definition of source endpoints (the small blue ones)
      sourceEndpoint = {
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
        connectorStyle:connectorPaintStyle,
        hoverPaintStyle:endpointHoverStyle,
        connectorHoverStyle:connectorHoverStyle
      };

      targetEndpoint = {
        endpoint:"Dot",         
        paintStyle:{ fillStyle:"#7AB02C",radius:11 },
        maxConnections: -1,
        connector:[ "Flowchart", { stub:[40, 60], gap:10, cornerRadius:5, alwaysRespectStubs:true } ],                                
        connectorStyle:connectorPaintStyle,
        hoverPaintStyle:endpointHoverStyle,
        connectorHoverStyle:connectorHoverStyle,
        isSource:true,
        isTarget:true  
      };
    }
  };
});

