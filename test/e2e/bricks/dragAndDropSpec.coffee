describe 'GENius', ->

  describe 'bricks', ->

    beforeEach ->
      browser.get('/');

      browser.driver.sleep(500)
      browser.waitForAngular()

    it 'should be draggable and droppable', ->
      expect(element(findBy.id('brick-and')).getText()).toEqual('AND')

      protractor.getInstance().actions().dragAndDrop(element(findBy.id('brick-and')), { x: -250, y:  150 }).perform();

      browser.driver.sleep(500)

      expect(element(findBy.css('.ui-draggable.brick-and'))).toNotEqual(null)

    it 'should be deleteable after being dropped on the workspace', ->
      protractor.getInstance().actions().dragAndDrop(element(findBy.id('brick-and')), { x: -250, y:  150 }).perform()

      browser.driver.sleep(500)

      $brickElement = element(findBy.css('.ui-draggable.brick-and'))
      protractor.getInstance().actions().mouseMove($brickElement).perform()

      browser.driver.sleep(500)

      # element(findBy.css('.fa-times')).click()

      # browser.driver.sleep(500)

      expect(element(findBy.css('.ui-draggable.brick-and'))).toNotEqual($brickElement)