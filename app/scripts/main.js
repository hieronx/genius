window.hoodie  = new Hoodie('http://127.0.0.1:9000/')

$( function() {
  
  var updatePreview = function() {
  };

  hoodie.account.on('signout signin', updatePreview)

  // hoodie.account.signIn("jeroen", "wachtwoord")
})