window.hoodie  = new Hoodie('http://127.0.0.1:9000/')

$( function() {
  
  var updatePreview = function() {
  };

  hoodie.account.on('signout signin', updatePreview)

  

  $('#workspace .btn-toolbar .btn, #library .filters .btn').tooltip({
    container: 'body'
  });
  
  $('.nav a').tooltip({
    placement: 'bottom',
    container: 'body'
  });
  
  // $('#loginModal').modal();
  
});