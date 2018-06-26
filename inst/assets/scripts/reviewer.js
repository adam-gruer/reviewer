$( function() {

    $("#dialog-decide").dialog({
      resizable: false,
      height: "auto",
      width: 400,
      modal: true,
      autoOpen: false,
      buttons: {
        "Accept": function() {
           replace_span($(this).data('span'), 'accept');
           $(this).dialog( "close" );
        },
        "Reject": function() {
            replace_span($(this).data('span'), 'reject');
            $(this).dialog( "close" );
         },
        Cancel: function() {
          $(this).dialog( "close" );
        }
      }
    });

    $("#placeholder")
         .on("click", "span.insertion, span.deletion",
             function (eventObject) {
        // this is the span that was clicked
        $("#dialog-decide").data('span', $(this)).dialog("open");

    } );

     Shiny.addCustomMessageHandler("complete",
                                  function(message) {
                                     $("#output").append(
                                                        $('#placeholder')
                                                        .children()
                                                        .not('.ui-dialog')
                                                        .not('script')
                                                        .not('#output')
                                                          );

                                      var html = $('#output').html();

                                      Shiny.onInputChange('reviewed',html);
                                     }
                                  );

  } );

  function replace_span(span,decision) {

      if ((span.hasClass('insertion') && decision == 'reject') ||
      (span.hasClass('deletion') && decision == 'accept') ) {

                // find index of the span in contents of its parent
                i = span.parent().contents().index(span);
                // if element before i is a text node ending with space,
                // remove the trailing space.
                if (i > 0){
                   text_node =   span.parent().contents().filter(
                       function (index) {
                           return index === i - 1 && this.nodeType === 3;
                       }
                   ).replaceWith(function() {
                       var text = $(this).text();
                       text = text.replace(/\s?$/,'');
                       return text  ;
                   }).end();

                }
                 span.remove();
          } else {

            span.replaceWith(function(){
                return  $(this).text();
            });

          }

  }
