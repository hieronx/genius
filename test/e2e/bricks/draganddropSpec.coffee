describe 'GENius', ->

  describe 'bricks', ->

    beforeEach ->
      browser.get('/');

    it 'should be be draggable and droppable', ->
    	expect(element(findBy.id('brick-and')).getText()).toEqual('AND')
      # handle = $(".brick-and")
			# ptor.actions().dragAndDrop(handle,{x:1000,y:0}).perform();
