// https://stackoverflow.com/questions/5930063/showing-a-modal-dialog-with-jquery-ui-without-an-element

function decide_modal(title, text) {
    var div = $('<div>').html(text).dialog({
        title: title,
        modal: true,
        close: function() {
            $(this).dialog('destroy').remove();
        },
        buttons: [{
            text: "Ok",
            click: function() {
                $(this).dialog("close");
            }}]
    })
};
decide_modal("Test", "This is a test modal dialog");