describe 'GENius', ->

  describe 'bricks', ->

    beforeEach ->
      browser.get('/');

    it 'should be draggable and droppable', ->
      expect(element(findBy.id('brick-and')).getText()).toEqual('AND')
