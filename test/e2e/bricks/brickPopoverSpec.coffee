describe 'GENius', ->

	describe 'bricks', ->

	beforeEach ->
		browser.get('/')
		browser.driver.sleep(500)

	it 'should have an popover when ', ->
		protractor.getInstance().actions().dragAndDrop(element(findBy.id('brick-and')), { x: -250, y:  150 }).perform()

		browser.driver.sleep(500)

		$brickElement = element(findBy.css('.ui-draggable.brick-and'))
		$brickElement.click()

		browser.driver.sleep(500)

		$popOverElement = element(findBy.tagName('popover'))
		expect($popOverElement).toNotEqual(null)