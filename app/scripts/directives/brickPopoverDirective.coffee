app = angular.module("geniusApp")

app.directive "brickPopover", ($compile, $rootScope, Brick, popoverTypesService) ->
  restrict: 'A'
  link: (scope, element, attributes) ->
    options = scope.$eval(attributes.brickPopover)

    $brickId = $(element).attr('id').slice 6
    $brick = {}

    Brick.find($brickId).done (fetchedBrick) ->
      $brick = fetchedBrick

    brickForm = popoverTypesService.type($(element).data('type'))
    $(brickForm).data('brickId', $brickId)

    $compile(brickForm)($rootScope)

    # Activate the popover with settings
    element.popover(
      trigger:'click'
      html : true
      placement: 'bottom'
      title: element.data('type') + ' brick'
      content: brickForm
    )