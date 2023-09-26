document.addEventListener("turbo:load", function() {
  $('#chatbox-button').click(function () {
    var chatbox_content = $('.chatbox-content');
    var chatbox_form = $('.chatbox-form');
    var chatbox_button = $('#chatbox-button');

    if (chatbox_content.css('display') === 'none') {
      chatbox_content.css('display', 'inline-block');
      chatbox_form.css('display', 'inline-block');
      chatbox_button.removeClass('blink');
      chatbox_content.animate({ scrollTop: 9999 }, 'slow');
    } else {
      chatbox_content.css('display', 'none');
      chatbox_form.css('display', 'none');
      chatbox_button.addClass('blink');
    }
  })
});

