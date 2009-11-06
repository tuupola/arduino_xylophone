$('#editor img').click(function() {
    $(this).toggleClass('play');
    $(this).prev().click();
});
