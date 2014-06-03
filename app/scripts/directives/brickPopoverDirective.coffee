app = angular.module("geniusApp")

app.directive "brickPopover", ($compile, $rootScope, Brick) ->
  restrict: 'A'
  link: (scope, element, attributes) ->
    options = scope.$eval(attributes.brickPopover)

    $brickId = $(element).attr('id').slice 6
    $brick = {}

    Brick.find($brickId).done (fetchedBrick) ->
      $brick = fetchedBrick

    brickForm = angular.element '<form class="brick-form form-horizontal" role="form">
                  <div class="form-group">
                    <label for="K1"> K1 </label>
                    <input type="text" id="K1" class="form-control" name="K1 (Complex binding)" placeholder="Complex binding">
                  </div>
                  <div class="form-group">
                    <label for="K2">K2</label><input type="text" id="K2" class="form-control" name="K2 (Catalytic rate)" placeholder="Catalytic rate">
                  </div>
                  <div class="form-group">
                    <label for="K3">K3</label><input type="text" id="K3" class="form-control" name="K3 (Complex division)" placeholder="Complex division">
                  </div>
                  <div class="form-group">
                    <label for="K4">K4</label><input type="text" id="K4" class="form-control" name="K4 (Reverse catalytic rate)" placeholder="Reverse catalytic rate">
                  </div>
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