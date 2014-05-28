app = angular.module("geniusApp")

app.directive "updateBrick", ($compile, $rootScope, Brick) ->
  restrict: 'A'
  link: (scope, element, attributes) ->
    options = scope.$eval(attributes.updateBrick)

    # Handles form data when submitted and updates brick in database
    element.on 'submit', (event) ->
      event.preventDefault()
      $this = $(this)
      $brickId = $this.data('brickId')
      $attributes = {}

      element.find('input').each (key, prop) ->
      	$attributes[$(prop).attr('name')] = $(prop).val();

      Brick.update($brickId, $attributes).done (updatedBrick) ->
      	console.log updatedBrick

      # $(element).parent().parent().hide()