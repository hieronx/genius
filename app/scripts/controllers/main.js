'use strict';

angular.module('geniusApp')
  .controller('MainCtrl', function ($scope, hoodieArray) {

    $scope.delete = function(item) {
      var idx = $scope.todos.indexOf(item);
      $scope.todos.splice(idx, 1);
    };

    $scope.add = function (title) {
      $scope.todos.push({
        title: title
      });
      $scope.newTodo = '';
    }

    hoodieArray.bind($scope, 'todos', 'todo');
  });