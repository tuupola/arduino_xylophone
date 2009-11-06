
$(function() {
    $('input:checkbox:checked').each(function() {
        $(this).next().addClass('play');        
    });
    $('#editor img').click(function() {
        $(this).toggleClass('play');
        $(this).prev().click();
    });
});
