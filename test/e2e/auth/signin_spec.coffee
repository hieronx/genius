describe 'GENius', ->

  describe 'authentication', ->

    beforeEach ->
      browser.get('/');
      browser.ignoreSynchronization = true
      browser.driver.sleep(500)

    it 'should allow users to sign up', ->
      element(findBy.id('nav-dropdown')).click()
      element(findBy.id('signup')).click()

      element(findBy.id('username')).sendKeys('John Doe')
      element(findBy.id('password')).sendKeys('password')
      element(findBy.id('password_confirmation')).sendKeys('password')

      element(findBy.id('modalSubmitButton')).click()