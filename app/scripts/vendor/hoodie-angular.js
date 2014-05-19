'use strict';
angular.module('hoodie-angular', ['ui.bootstrap']).

  factory('hoodie', function () {
    return new Hoodie();
  }).

  provider('hoodie',function(){

    this.url = undefined;

    this.setUrl = function(url){
      this.url = url;
    }

    this.$get = [function(){
      if(!this.url){
        throw new Error('You should config hoodieProvider.url before requiring hoodie');
      }
      return new Hoodie(this.url);
    }];
  }).

  directive('hoodieHideAuthenticated',['hoodie', function(hoodie){
    return {
      restrict: 'AC',
      link: function($scope, element){
        function getUsername(){
          return hoodie.account.username;
        }

        $scope.$watch(getUsername, function(username){
          if(username){ element.hide();
          }
          else { element.show(); }
        });
      }
    }
  }]).
  directive('hoodieShowAuthenticated',['hoodie', function(hoodie){
    return {
      restrict: 'AC',
      link: function($scope, element){
        function getUsername(){
          return hoodie.account.username;
        }

        $scope.$watch(getUsername, function(username){
          if(username){  element.show(); }
          else { element.hide(); }
        });
      }
    }
  }]).
  directive('hoodieSigninButton',['hoodie', '$dialog', function(hoodie, $dialog){
    return {
      restrict: 'AC',
      template: '<button class="btn btn-primary" hoodie-hide-authenticated>Sign In</button>',
      replace: true,
      link: function($scope, element){
        var dialog = $dialog.dialog({
          backdrop: true,
          keyboard: true,
          dialogFade: true,
          backdropFade: true,
          dialogClass: 'modal login',
          backdropClick: true,
          templateUrl: 'views/login.html',
          controller: 'LoginCtrl'
        });

        element.on('click', function(){
          $scope.$apply(function(){
            dialog.open();
          });
        });
      }
    }
  }]).
  directive('hoodieSignoutButton',['hoodie', function(hoodie){
    return {
      restrict: 'AC',
      template: '<button class="btn btn-primary" hoodie-show-authenticated>Sign Out</button>',
      replace: true,
      scope:{},
      link: function($scope, element){
        element.on('click', function(){
          hoodie.account.signOut();
        });

      }
    }
  }]).
  directive('hoodieUserName', ['hoodie', function(hoodie){
    return {
      restrict: 'AC',
      link: function($scope, element) {

        function getUsername(){
          return hoodie.account.username;
        }

        $scope.$watch(getUsername, function(username){
          if(username){ element.text(username); }
          else { element.text(''); }
        });
      }
    };
  }]).
  directive('hoodieSignupForm', ['hoodie', function(hoodie){
    return {
      scope: {
        'email': '=',
        'password': '=',
        'passwordConfirmation': '='
      },
      restrict: 'EA',
      templateUrl: 'views/signup.html',
      replace: true,
      link: function($scope) {
        $scope.signUp = function(){
          hoodie.account.signUp($scope.email, $scope.password, $scope.passwordConfirmation);
        }
      }
    };
  }]).
  directive('hoodieSigninForm', ['hoodie', function(hoodie){
    return {
      scope: {
        'email': '=',
        'password': '='
      },
      restrict: 'EA',
      templateUrl: 'views/signin.html',
      replace: true,
      link: function($scope){
        $scope.signIn = function(){
          hoodie.account.signIn($scope.email, $scope.password);
        }
      }
    }
  }]).
  service('hoodieNotifications', ['hoodie', '$rootScope', function(hoodie, $rootScope){
    this.list = [];

    hoodie.on('account:error:unauthenticated remote:error:unauthenticated', function(){
      this.addNotification('Authentication Failed!', 'error');
    });

    this.add =  function(text, type){
      this.list.push({msg:text, type:type});
      $rootScope.$digest();
    }

    this.remove= function(alert){
      this.list.splice( this.list.indexOf(alert), 1 );
      $rootScope.$digest();
    }
  }]).
  directive('hoodieAlerts', ['hoodieNotifications', function(notifications){
    return {
      scope: {},
      restrict: 'EA',
      replace: true,
      template: '<div>'+
                  '<alert ng-repeat="alert in notifications.list" type="alert.type" close="closeAlert(alert)">'+
                    '{{alert.msg}}'+
                  '</alert>'+
                '</div>',
      link: function($scope) {
        $scope.notifications = notifications;

        $scope.closeAlert = function(alert) {
          $scope.notifications.remove(alert);
        };
      }
    }
  }]).
  controller('LoginCtrl',['$scope', 'hoodie', 'dialog', 'hoodieNotifications', function($scope, hoodie, dialog, notifications){
    $scope.close = function(){
      dialog.close();
    }

    $scope.signIn = function(email, password){
      hoodie.account.signIn(email, password).fail(addError);
    }

    $scope.signUp = function(email, password, passwordConfirmation){
      hoodie.account.signUp(email, password, passwordConfirmation).fail(addError);
    }

    function addError(error){
      notifications.add(error.reason, 'error');
    }

    hoodie.account.on('authenticated', $scope.close);
    hoodie.account.on('signup', $scope.close);
  }]);