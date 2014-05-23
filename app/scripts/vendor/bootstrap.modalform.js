!function ($) {

  "use strict"; // jshint ;_;

  $( function() {
    var modalId = "modal-form-" + parseInt(Math.random() * 1000, 10);
    var $cont = $('<div id="'+modalId+'"></div>');
    $('body').append( $cont );

    $.modalForm = function(options) {
      var fields = options.fields || [];
      var title  = options.title  || options.submit;
      var submit = options.submit || 'submit';
      var $modal, field, type, html = "";

      html += "<div class=\"modal fade\">";
      html += " <div class=\"modal-dialog\">";
      html += "  <form class=\"modal-content form-horizontal\">";
      if (title) {
        html += "    <div class=\"modal-header\">";
        html += "      <h4 class=\"modal-title\">";
        html += "      "+title;
        html += "        <button type=\"button\" class=\"close\" data-dismiss=\"modal\" aria-hidden=\"true\">&times;</button>";
        html += "      </h4>";
        html += "    <\/div>";
      }
      html += "    <div class=\"modal-body\">";
      while (field = fields.shift()) {
        type = /password/.test(field) ? 'password' : 'text';
        name = field.slice(0, 1).toUpperCase()+field.slice(1).split('_').join(' ')
        html += "     <div class=\"form-group\">";
        html += "      <label class=\"col-sm-4 control-label\">"+name+"<\/label>";
        html += "      <div class=\"col-sm-7\">";
        html += "       <input class=\"form-control\" type=\""+type+"\" name=\""+field+"\" id=\"" + field + "\" placeholder=\""+field.replace(/_/g, ' ')+"\" \/>";
        html += "      <\/div>"
        html += "     <\/div>";
      }
      html += "    <\/div>";
      html += "    <div class=\"modal-footer\">";
      html += "      <button type=\"submit\" class=\"btn btn-primary\">"+submit+"<\/button>";
      html += "    <\/div>";
      html += "  <\/form>";
      html += " <\/div>";
      html += "<\/div>";

      // make sure that only one modal is visible
      $modal = $( html );
      $cont.html('').append( $modal );

      $modal.modal();
      $modal.modal('show');

      $modal.on('submit', 'form', function(event){
        event.preventDefault();
        event.stopPropagation();

        var inputs = {};
        var $form = $(event.target);

        $form.find('[name]').each( function () {
          inputs[this.name] = this.value;
        });

        $modal.trigger('submit', inputs);
      });

      $modal.on('error', function(event, error) {
        $modal.find('.alert').remove();
        $modal.find('.modal-body').before('<div class="alert alert-danger">'+error.message+'</div>');
      });

      $modal.on('shown', function() {
        $modal.find('input').eq(0).focus()
      })

      return $modal;
    };
  })
}( window.jQuery )
