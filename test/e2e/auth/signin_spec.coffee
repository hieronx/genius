describe 'GENius', ->

  describe 'authentication', ->

    beforeEach ->
      browser.ignoreSynchronization = true
      browser.get('/');
      browser.driver.sleep(500)

    it 'should allow users to sign up', ->
      elementToFind = findBy.id('nav-dropdown')

      browser.driver.isElementPresent(elementToFind).then (isPresent) ->
        element(elementToFind).click().then ->
          element(findBy.id('signup')).click()

          element(findBy.id('username')).sendKeys('John Doe')
          element(findBy.id('password')).sendKeys('password')
          element(findBy.id('password_confirmation')).sendKeys('password')

          element(findBy.id('modalSubmitButton')).click()