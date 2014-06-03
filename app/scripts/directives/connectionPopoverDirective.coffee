app = angular.module("geniusApp")

app.directive "connectionPopover", ($compile, $rootScope) ->
  restrict: 'EA'
  link: (scope, element, attributes) ->
    options = scope.$eval(attributes.connectionPopover)
    element.popover(
      trigger:'click',
      html : true,
      placement: 'bottom',
      content: '<form role="form">
                  <input type="text" class="form-control" placeholder="Propertie1">
                  <input type="text" class="form-control" placeholder="Propertie2">
                  <button type="submit" class="btn btn-block btn-primary">Save</button>
                </form>'
    )

    # Ensure that the bricks that are connected by this connection cannot be dragged when 
    # a popover is active on the label
    element.on 'click', (event) ->
      $this = $(this)
      $source = $('#' + $this.data('sourceId'))
      $target = $('#' + $this.data('targetId'))

      if $source.hasClass('labelDisabled') || $target.hasClass('labelDisabled')
        if $source.hasClass('dragDisabled') || $target.hasClass('dragDisabled')
          $source.removeClass('labelDisabled')
          $target.removeClass('labelDisabled')
        else
          $source.removeClass('labelDisabled').draggable('enable')
          $target.removeClass('labelDisabled').draggable('enable')
      else 
        $source.addClass('labelDisabled').draggable('disable')
        $target.addClass('labelDisabled').draggable('disable')

