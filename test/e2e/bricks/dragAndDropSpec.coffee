describe 'GENius', ->

	describe 'bricks', ->

		beforeEach ->
			browser.get('/')
			browser.driver.sleep(500)

			it 'should be draggable and droppable', ->
				expect(element(findBy.id('brick-and')).getText()).toEqual('AND')
				protractor.getInstance().actions().dragAndDrop(element(findBy.id('brick-and')), { x: -250, y:  150 }).perform()
				browser.driver.sleep(500)
				expect(element(findBy.id('brick-1'))).toNotEqual(null)
			return
