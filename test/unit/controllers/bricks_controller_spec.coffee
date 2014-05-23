"use strict"

describe "Controller: BricksCtrl", ->

  # load the controller's module
  beforeEach module("geniusApp")

  # Initialize the controller and a mock scope
  beforeEach inject(($controller, $rootScope) ->
    scope = $rootScope.$new()
    BricksCtrl = $controller("BricksCtrl",
      $scope: scope
    )
  )

  it "should have a list of 5 gates", ->
    expect(BricksCtrl.gates.length).toBe 5
