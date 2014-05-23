"use strict"

angular.module("geniusApp").directive "brickPopover", ($compile, $rootScope) ->
    restrict: 'A'
    link: (scope, element, attributes) ->
        options = scope.$eval(attributes.brickPopover)
        console.log "hello world"
        # $this = $('.canvas-element')
        # show = false
        $this = element
        $this.on 'click', ->
            alert 'swag'
        
        # element.popover(
        #     trigger:'click',
        #     html : true,
        #     placement: 'bottom',
        #         content: () ->               
        #             return "<p>sdjhfbdsjf</p>"
        # ) 
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
