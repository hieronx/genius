'use strict';

angular
  .module('geniusApp', [
    'ngCookies',
    'ngResource',
    'ngSanitize',
    'ngRoute',
    'hoodie'
  ])
  .config(function ($routeProvider) {
    $routeProvider
      .when('/', {
        templateUrl: 'views/main.html',
        controller: 'MainCtrl'
      })
      .otherwise({
        redirectTo: '/'
      });
  })
  .config(function(hoodieProvider) {
    hoodieProvider.url('http://127.0.0.1:9000/');
  });
