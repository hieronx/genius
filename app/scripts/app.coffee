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

window.hoodie = new Hoodie("http://127.0.0.1:9000/")
