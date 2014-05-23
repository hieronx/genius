describe 'GENius', ->

  describe 'Authentication sign in', ->

    beforeEach ->
      browser.get('app/index.html');

    it 'should log in as user completes the login form', ->
      browser.debugger();
