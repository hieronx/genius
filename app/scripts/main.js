window.hoodie  = new Hoodie('http://127.0.0.1:9000/')

$( function() {

  var updatePreview = function() {
  };

  hoodie.account.on('signout signin', updatePreview)
  hoodie.account.signOut();

  $('.btn-facebook').on('click', function() {
    hoodie.account.socialLogin("facebook")
    .done(function(data){
        $('#loginModal').modal('hide');

        hoodie.account.socialGetProfile("facebook")
        .done(function(data){
            $('#data').append('<br /><br />'+JSON.stringify(data));
        })
        .fail(function(error){
            console.log(error);
        })
    })
    .fail(function(error){
        console.log(error);
    })
  })

  $('#workspace .btn-toolbar .btn, #library .filters .btn').tooltip({
    container: 'body'
  });

  $('.nav a').tooltip({
    placement: 'bottom',
    container: 'body'
  });
  
  // $('#loginModal').modal();
  
});
