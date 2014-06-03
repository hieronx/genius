app = angular.module("geniusApp")

app.directive "brickPopover", ($compile, $rootScope, Brick) ->
  restrict: 'A'
  link: (scope, element, attributes) ->
    options = scope.$eval(attributes.brickPopover)

    $brickId = $(element).attr('id').slice 6
    $brick = {}

    Brick.find($brickId).done (fetchedBrick) ->
      $brick = fetchedBrick

    brickForm = angular.element '<form class="brick-form" role="form">
                  <input type="text" class="form-control" name="propertie1" placeholder="Propertie1">
                  <input type="text" class="form-control" name="propertie2" placeholder="Propertie2">
                  <input type="text" class="form-control" name="propertie3" placeholder="Propertie3">
                  <button type="submit" class="submit-button btn btn-block btn-primary">Save</button>
                </form>'
    brickForm.data('brickId', $brickId)

    # Ensure that stored data is displayed in the form
    brickForm.find('input').each (key, input) ->     
      $this = $(this)
      $name = $this.attr('name') 
      $this.val($brick[$name])

    $compile(brickForm)($rootScope)

    # Activate the popover with settings
    element.popover(
      trigger:'click'
      html : true
      placement: 'bottom'
      title: element.data('type') + ' brick'
      content: brickForm
    )