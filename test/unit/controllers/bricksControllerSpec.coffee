describe 'BricksCtrl', ->
  scope = undefined
  controller = undefined

  beforeEach module("geniusApp")

  beforeEach inject ($rootScope, $controller) ->
    scope = $rootScope.$new()
    controller = $controller 'BricksCtrl',
      $scope: scope

  it "should have a list of 5 gates", ->
    expect(scope.gates.length).toBe 5
