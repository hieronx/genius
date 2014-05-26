app = angular.module("geniusApp")

class MainCtrl extends BaseCtrl

  @register app, 'MainCtrl'
  @inject "$scope", "Brick", "dropService"
