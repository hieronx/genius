app = angular.module("geniusApp")

app.directive "brickPopover", ($compile, $rootScope, popoverTypesService) ->
  restrict: 'A'
  link: (scope, element, attributes) ->
    options = scope.$eval(attributes.brickPopover)

    $brickId = $(element).attr('id').slice 6
    $brick = Brick.find((m) -> m.id() == $brickId)

    brickForm = popoverTypesService.type(element.data('type'))
    brickForm.data('brickId', $brickId)

    # Ensure that stored data is displayed in the form
    brickForm.find('input').each (key, input) ->
      $this = $(this)
      $name = $this.attr('name')
      $this.val($brick.attr($name))

    $compile(brickForm)($rootScope)

    # Activate the popover with settings
    element.popover(
      trigger:'click'
      html : true
      placement: 'bottom'
      title: element.data('type') + ' brick'
      content: brickForm
    )
