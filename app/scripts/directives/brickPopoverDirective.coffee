app = angular.module("geniusApp")

app.directive "brickPopover", ($compile, $rootScope) ->
  restrict: 'A'
  link: (scope, element, attributes) ->
    options = scope.$eval(attributes.brickPopover)

    brickForm = angular.element '<form class="brick-form" role="form" update-brick>
                  <input type="text" class="form-control" name="propertie1" placeholder="Propertie1">
                  <input type="text" class="form-control" name="propertie2" placeholder="Propertie2">
                  <input type="text" class="form-control" name="propertie3" placeholder="Propertie3">
                  <button type="submit" class="btn btn-block btn-primary">Save</button>
                </form>'
    $compile(brickForm)($rootScope)

    element.popover(
      trigger:'click',
      html : true,
      placement: 'bottom',
      title: element.data('type') + ' brick'
      content: brickForm
    )