"use strict"

angular.module("geniusApp").directive "brickPopover", ($compile, $rootScope) ->
    restrict: 'A'
    link: (scope, element, attributes) ->
        options = scope.$eval(attributes.brickPopover)
        console.log "hello world"
        # $this = $('.canvas-element')
        # show = false
        # $this = element
        # $this.on 'click', ->
        #     alert 'swag'

        element.popover(
            trigger:'click',
            html : true,
            placement: 'bottom',
            title: 'Properties'
            content: '<form class="form-horizontal" role="form">
                          <div class="form-group">
                            <label for="Gene1" class="col-sm-2 control-label">Email</label>
                            <div class="col-sm-10">
                              <input type="email" class="form-control" id="inputEmail3" placeholder="Email">
                            </div>
                            <label for="inputPassword3" class="col-sm-2 control-label">Password</label>
                            <div class="col-sm-10">
                              <input type="password" class="form-control" id="inputPassword3" placeholder="Password">
                            </div>
                          </div>
                          <div class="form-group">
                            <div class="col-sm-offset-2 col-sm-10">
                              <button type="submit" class="btn pull-right btn-primary">Save</button>
                            </div>
                          </div>
                        </form>'
        )
        # $this.on 'click', ->


        #    if show
        #         $(this).children('form').hide()
        #         show = false
        #     else
        #         $(this).children('form').show()
        #         show = true

    #  element.popover(    
    #     trigger:'click',
    #     html : true,
    #     placement: 'bottom',
    #         content: () ->               
    #             return element.find('div')
    # )
    # templateUrl: 'main.html'
