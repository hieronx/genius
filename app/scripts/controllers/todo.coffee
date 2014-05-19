#global todomvc
"use strict"

###
The main controller for the app. The controller:
- retrieves and persists the model via the todoStorage service
- exposes the model to the template and provides event handlers
###
angular.module("geniusApp").controller "TodoCtrl", TodoCtrl = ($scope, $location, todoStorage, filterFilter) ->
  promise = todoStorage.get()
  promise.done (loaded) ->
    todos = $scope.todos = loaded

  $scope.newTodo = ""
  $scope.editedTodo = null
  $scope.$watch "todos", (->
    $scope.remainingCount = filterFilter(todos,
      completed: false
    ).length
    $scope.completedCount = todos.length - $scope.remainingCount
    $scope.allChecked = not $scope.remainingCount
    todoStorage.put todos
  ), true
  $location.path "/"  if $location.path() is ""
  $scope.location = $location
  $scope.$watch "location.path()", (path) ->
    $scope.statusFilter = (if (path is "/active") then completed: false else (if (path is "/completed") then completed: true else null))

  $scope.addTodo = ->
    newTodo = $scope.newTodo.trim()
    return unless newTodo.length
    todos.push
      title: newTodo
      completed: false

    $scope.newTodo = ""

  $scope.editTodo = (todo) ->
    $scope.editedTodo = todo

  $scope.doneEditing = (todo) ->
    $scope.editedTodo = null
    todo.title = todo.title.trim()
    $scope.removeTodo todo  unless todo.title

  $scope.removeTodo = (todo) ->
    todos.splice todos.indexOf(todo), 1

  $scope.clearCompletedTodos = ->
    $scope.todos = todos = todos.filter (val) ->
      not val.completed
    )

  $scope.markAll = (completed) ->
    todos.forEach (todo) ->
      todo.completed = completed
