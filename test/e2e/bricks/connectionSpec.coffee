# describe 'GENius', ->

#   describe 'connections', ->

#     beforeEach ->
#       browser.get('/');
#       browser.driver.sleep(500)
#       protractor.getInstance().actions().dragAndDrop(element(findBy.id('brick-and')), { x: -250, y:  150 }).perform();
#       protractor.getInstance().actions().dragAndDrop(element(findBy.id('brick-and')), { x: -350, y:  150 }).perform();
#       $brickElements = element(findBy.css('.ui-draggable.brick-and'))
#       $sourceElement = $brickElements.get(0)
#       $targetElement = $brickElements.get(1)
#       protractor.getInstance().actions().dragAndDrop($sourceElement, $targetElement).perform()

#     it 'should be possible to create between bricks', ->
#       expect(element(findBy.css('._jsPlumb_connector'))).toNotEqual(null)
#       browser.driver.sleep(500)

#     it 'should be removed when the source or target is removed', ->
#       protractor.getInstance().actions().mouseMove($sourceElement).perform()
#       element(findBy.css('.fa-times')).get(0).click()
#       expect(element(findBy.css('._jsPlumb_connector'))).toEqual(null)

