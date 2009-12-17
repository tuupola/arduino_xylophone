/*
 * Xylophone - Arduino controlled xylophone
 *
 * Copyright (c) 2009 Mika Tuupola
 *
 * Licensed under the MIT license:
 *   http://www.opensource.org/licenses/mit-license.php
 *
 * Project home:
 *   https://github.com/tuupola/arduino_xylophone
 *
 */
 
$(function() {
    
    if ($('#videoSpan').size()) {
        /* Show player only if video has been uploaded to webserver. */
        var ajax_url = '/song/ajax/' + $('#videoSpan').attr('title');

        /* Check every 5 seconds if video has been uploaded. */

        var interval_id = setInterval(function() {
            $('#videoSpan').load(ajax_url);
        }, 5000);

        /* If video was found stop checking and start player. */

        $('#videoSpan').ajaxComplete(function(request, settings){
            if (settings.status===404){
                $('#videoSpan').html('<img src="/img/spinner.gif" id="spinner" />');
            } else {
                clearInterval(interval_id);
                flowplayer("player", "/swf/flowplayer-3.1.5.swf");            
            }
        }).load(ajax_url);        
    }
     
    /* Initialize Soundmanager for preview sounds. */    
    soundManager.debugMode = false;    
    soundManager.url = '/swf/';
    
    soundManager.defaultOptions.autoLoad = true;
        
    soundManager.onready(function(status) {
        if (status.success) {
            soundManager.createSound({
                id: 'C',
                url: '/sound/c1.mp3'
            });
            soundManager.createSound({
                id: 'D',
                url: '/sound/d1.mp3'
            });
            soundManager.createSound({
                id: 'E',
                url: '/sound/e1.mp3'
            });
            soundManager.createSound({
                id: 'F',
                url: '/sound/f1.mp3'
            });
            soundManager.createSound({
                id: 'G',
                url: '/sound/g1.mp3'
            });
            soundManager.createSound({
                id: 'A',
                url: '/sound/a1.mp3'
            });
            soundManager.createSound({
                id: 'B',
                url: '/sound/b1.mp3'
            });
            soundManager.createSound({
                id: 'c',
                url: '/sound/c2.mp3'
            });
            soundManager.createSound({
                id: 'd',
                url: '/sound/d2.mp3'
            });
            soundManager.createSound({
                id: 'e',
                url: '/sound/e2.mp3'
            });
            soundManager.createSound({
                id: 'f',
                url: '/sound/f2.mp3'
            });
            soundManager.createSound({
                id: 'g',
                url: '/sound/g2.mp3'
            });
            soundManager.createSound({
                id: 'a',
                url: '/sound/a2.mp3'
            }); 
        }        
    });
        
    /* Highlight all checked notes when user clicks back button. */
    $('input:checkbox:checked').each(function() {
        $(this).next().addClass('play');        
    });
    
    /* Handle clicks on notes. */
    $('#editor img').click(function() {
        //console.log($(this).prev().val());

        /* Play a preview sound when note is clicked. */
        soundManager.play($(this).attr('class'));
        
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
            });
            $('img', new_row).removeClass('play');
            $('input', new_row).removeAttr('checked');
            new_row.css('display', 'none');
            
            new_row.insertAfter($(this).parent());
            new_row.fadeIn('fast');
        }
        
    });
    
    $('#preview').click(function(){
        var preview_notes = [];
        $('#editor > span').each(function() {
            if ($(':checked', this).size()) {
                $(':checked', this).each(function() {
                    preview_notes.push($(this).val());
                });                
            } else {
                preview_notes.push(' ');                
            }
        });
        //console.log(preview_notes);
        var i = 0;
        var interval = setInterval(function() {
            //console.log(preview_notes[i]);
            soundManager.play(preview_notes[i++]);
            if (i == preview_notes.length) {
                clearInterval(interval);
            } 
        }, 220);
        
    });
    
});
