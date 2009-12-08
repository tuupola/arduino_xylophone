
$(function() {

    /* For the pages were player should be displayed. */
    if ($('#player').size()) {
        flowplayer("player", "/swf/flowplayer-3.1.5.swf");         
    }
        
    $('input:checkbox:checked').each(function() {
        $(this).next().addClass('play');        
    });
    
    $('.editor img').click(function() {
        //console.log($(this).prev().val());
        
        var notes_before = $(this).parent().children('input:checkbox:checked');
        
        /* Check the checkbox so note will be played.  */
        /* Rest of the code is just to make sure there */
        /* is only two active notes per row.           */
        $(this).toggleClass('play');
        $(this).prev().click();
        
        var notes_after = $(this).parent().children('input:checkbox:checked');

        /* Make sure there is only two active notes per row. */
        if (2 < notes_after.size()) {
            notes_before.filter(':first').next('img').click();
        }
        
        /* If we are at last or sedond last row add a new row. */
        if (0 == $(this).parent().next('span').size()) {
            var num_rows = $('#editor_form > span').size();
            var new_row  = $(this).parent().clone(true);
            $(':input', new_row).each(function(key, input) {
                var new_name = $(input).attr('name')
                                       .replace(/notes\[\d*\]/, 'notes[' + num_rows + ']');
                $(input).attr('name', new_name);
            })
            $('img', new_row).removeClass('play');
            $('input', new_row).removeAttr('checked');
            new_row.css('display', 'none');
            
            new_row.insertAfter($(this).parent());
            new_row.fadeIn('fast');
        }
        
    });
    
});
