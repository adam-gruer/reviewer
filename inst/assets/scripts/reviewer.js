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

    $("span.insertion, span.deletion").on("click", function (eventObject) {
        // this is the span that was clicked
        $("#dialog-decide").data('span', $(this)).dialog("open");

    } );

     Shiny.addCustomMessageHandler("complete",
  function(message) {
    //alert(JSON.stringify(message));
     $("#output").append(
                        $('.gadget-absfill')
                        .children()
                        .not('.ui-dialog')
                        .not('script')
                        //.not('#complete')
                        .not('#output')
        );

        var html = $('#output').html();
        console.log(html);
        Shiny.onInputChange('reviewed',html);
  }
);


   // $( "#complete" ).on("click", function(eventObject) {
     //   $("#output").append(
     //                   $('.gadget-absfill')
     //                   .children()
      //                  .not('.ui-dialog')
      //                  .not('script')
      //                  .not('#complete')
      //                  .not('#output')
      //  );

      //  console.log($('#output').html());
      //  var message = $('#output').html();
      //  Shiny.onInputChange('reviewed',message);
        //Shiny.setInputValue(reviewed, $('#output').html());
        // var parts = [];
        // parts.push(encodeURI($('#output').html())) ;
        // console.log(parts[0]);

        //   var blob = new Blob(parts, {"type" : "text/html"});

        //   var blobURL = URL.createObjectURL(blob);

        //   var link = document.createElement("a"); // Or maybe get it from the current document
        //   link.href = blobURL;
        //   link.download = "aDefaultFileName.txt";
        //  link.innerHTML = "Click here to download the file";
        //   document.body.appendChild(link); // Or append it whereever you want





    //  });
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
