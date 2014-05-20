"use strict"

angular.module("geniusApp", [
  "ngCookies"
  "ngResource"
  "ngSanitize"
  "ngRoute"
  "ui.bootstrap"
  "underscore"
]).config ($routeProvider) ->
  $routeProvider.when("/",
    templateUrl: "views/main.html"
    controller: "MainCtrl"
  ).otherwise redirectTo: "/"