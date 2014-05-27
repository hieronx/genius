describe 'GENius', ->

	describe 'bricks', ->

		beforeEach ->
			browser.get('/')

			it 'should have an popover when ', ->
				expect(element(findBy.id('brick-and')).getText()).toEqual('AND')
				protractor.getInstance().actions().dragAndDrop(element(findBy.id('brick-and')), { x: -250, y:  150 }).perform()
				$brickElement = element(findBy.id('brick-1'))
				$brickElement.click()
				$popOverElement = element(findBy.tagName('popover'))
				expect($popOverElement).toNotEqual(null)
			return
				