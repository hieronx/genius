app = angular.module("geniusApp")

app.directive "updateBrick", ($compile, $rootScope) ->
  restrict: 'A'
  link: (scope, element, attributes) ->
    options = scope.$eval(attributes.updateBrick)

    # Handles form data when submitted and updates brick in database
    element.on 'submit', (event) ->
      event.preventDefault()
      element.find('input').each (key, prop) ->
      	console.log($(prop).val());