"use strict"

describe "Controller: BricksCtrl", ->

  beforeEach module("geniusApp")

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    BricksCtrl = $controller "BricksCtrl",
      $scope: scope

  it "should have a list of 5 gates", ->
    expect(scope.gates.length).toBe 5
