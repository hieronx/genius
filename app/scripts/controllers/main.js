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

angular.module("geniusApp").directive('isDraggable', function() {
  return {
    restrict: 'A',
    link: function(scope, elm, attrs) {
      var options = scope.$eval(attrs.isDraggable); //allow options to be passed in
      elm.draggable(options);
    }
  };
});
