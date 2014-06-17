app = angular.module("geniusApp")

app.directive "positionPopover", ($compile, $rootScope, popoverTypesService) ->
  restrict: 'A'
  link: (scope, element, attributes) ->
    options = scope.$eval(attributes.brickPopover)

    pid = $(element).attr('id')
    Position.find pid, (position) =>

      positionForm = popoverTypesService.type(element.data('type'))
      positionForm.data('id', pid)

      # Ensure that stored data is displayed in the form
      positionForm.find('input').each (key, input) ->
        $this = $(this)
        $name = $this.attr('name')
        $this.val(position.attr($name))

      $compile(positionForm)($rootScope)

      # Activate the popover with settings
      element.popover(
        trigger:'click'
        html : true
        placement: 'bottom'
        title: element.data('type') + ' brick'
        content: positionForm
      )
