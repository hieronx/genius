describe 'GENius', ->

  describe 'authentication', ->

    beforeEach ->
      browser.get('/')

      browser.driver.sleep(500)
      browser.waitForAngular()

    it 'should allow users to sign up', ->

      elementToFind = findBy.id('nav-dropdown')

      browser.driver.isElementPresent(elementToFind).then (isPresent) ->
        element(elementToFind).click().then ->
          element(findBy.id('signupLink')).click()

          element(findBy.id('username')).sendKeys('ProtractorTest')
          element(findBy.id('password')).sendKeys('password')
          element(findBy.id('password_confirmation')).sendKeys('password')

          element(findBy.id('modalSubmitButton')).click()

    it 'should allow users to sign in', ->

      elementToFind = findBy.id('nav-dropdown')

      browser.driver.isElementPresent(elementToFind).then (isPresent) ->
        element(elementToFind).click().then ->
          element(findBy.id('signinLink')).click()

          element(findBy.id('username')).sendKeys('ProtractorTest')
          element(findBy.id('password')).sendKeys('password')

          element(findBy.id('modalSubmitButton')).click()

    it 'should allow users to destroy their account', ->

      elementToFind = findBy.id('nav-dropdown')

      browser.driver.isElementPresent(elementToFind).then (isPresent) ->
        element(elementToFind).click().then ->
          element(findBy.id('destroyAccountLink')).click()

          alert = browser.driver.switchTo().alert().then (alert) ->
            alert.accept()