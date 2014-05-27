describe 'GENius', ->

  describe 'menu', ->

    beforeEach ->
      browser.get('/');

    # This test verifies that there is a default title and that 
    # the user is able to change the name of the current project
    it 'should allow users to change the project name', ->
      $projectName = element(findBy.id('title'))
      expect($projectName.getText()).toEqual('Unnamed biobrick project')
      $projectName.clear()
      expect($projectName.getText()).toEqual('')
      $projectName.sendKeys('New Project Name')
      expect($projectName.getText()).toEqual('New Project Name')
    return