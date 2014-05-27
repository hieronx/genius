app = angular.module("geniusApp")

app.directive "connectionPopover", ($compile, $rootScope) ->
  restrict: 'EA'
  link: (scope, element, attributes) ->
    options = scope.$eval(attributes.connectionPopover)
    element.popover(
      trigger:'click',
      html : true,
      placement: 'bottom',
      content: '<form class="form-horizontal" role="form">
                  <input type="text" class="form-control" placeholder="Propertie1">
                  <input type="text" class="form-control" placeholder="Propertie2">
                  <button type="submit" class="btn pull-right btn-primary">Save</button>
                </form>'
    )

    element.on 'click', (event) ->
      $connId = element.data('connection') 
      console.log($('#' + $connId))