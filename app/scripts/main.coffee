window.hoodie = new Hoodie("http://127.0.0.1:9000/")

$ ->
  updatePreview = ->

  hoodie.account.on "signout signin", updatePreview
