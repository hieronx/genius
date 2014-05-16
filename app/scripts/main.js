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

  $('#loginModal').modal();

  $(".brick").draggable({
    helper: "clone"
  });

  var index =1;
  $("#workspace").droppable({
    drop: function (event, ui) {

      var $canvas = $(this);

      if (!ui.draggable.hasClass('canvas-element')) {
        var $canvasElement = ui.draggable.clone();
        $canvasElement.addClass('canvas-element');
        $canvasElement.draggable({
          containment: '#workspace'
        });
        $canvasElement.addClass('brick-jsplumb').attr('id', 'brick-' + index);
        index++;
        $canvas.append($canvasElement);

        $par = $canvas.parent();
        $canvasElement.css({
          left: (ui.position.left + $par.outerWidth() + $par.position().left + 'px'),
          top: (ui.position.top),
          position: 'absolute'
        });
        $canvasElement.draggable( "destroy" );

        jsPlumb.addEndpoint($canvasElement.attr('id'), { anchor:[0, 0.2, -1, 0] }, sourceEndpoint);
        jsPlumb.addEndpoint($canvasElement.attr('id'), { anchor:[0, 0.8, -1, 0] }, sourceEndpoint);
        jsPlumb.addEndpoint($canvasElement.attr('id'), { anchor:[1, 0.5, 0, 0] }, targetEndpoint);

        jsPlumb.draggable($canvasElement);
      }
    }
  });
});

jsPlumb.ready(function() {
  jsPlumb.Defaults.Container = $('#workspace');

  endPointOptions = {
    endpoint:"Dot",
    isSource:true,
    // connectorStyle : { strokeStyle:"#666" },
    connector:[ "Flowchart", { cornerRadius:10 } ],
    isTarget:true
  };


  connectorPaintStyle = {
    lineWidth:4,
    strokeStyle:"#61B7CF",
    joinstyle:"round",
    outlineColor:"transparent"
  };

  // .. and this is the hover style.
  connectorHoverStyle = {
    lineWidth:4,
    strokeStyle:"#216477",
    outlineColor:"transparent"
  };

  endpointHoverStyle = {
    fillStyle:"#216477",
    strokeStyle:"#216477"
  };

  // the definition of source endpoints (the small blue ones)
  sourceEndpoint = {
    endpoint:"Dot",
    paintStyle:{
      strokeStyle:"#7AB02C",
      fillStyle:"transparent",
      radius:7,
      lineWidth:3
    },
    isSource:true,
    isTarget:true,
    connector:[ "Flowchart", { stub:[40, 60], gap:10, cornerRadius:5, alwaysRespectStubs:true } ],
    connectorStyle:connectorPaintStyle,
    hoverPaintStyle:endpointHoverStyle,
    connectorHoverStyle:connectorHoverStyle
  };

  targetEndpoint = {
    endpoint:"Dot",
    paintStyle:{ fillStyle:"#7AB02C",radius:11 },
    maxConnections: -1,
    connector:[ "Flowchart", { stub:[40, 60], gap:10, cornerRadius:5, alwaysRespectStubs:true } ],
    connectorStyle:connectorPaintStyle,
    hoverPaintStyle:endpointHoverStyle,
    connectorHoverStyle:connectorHoverStyle,
    isSource:true,
    isTarget:true
  };
});
