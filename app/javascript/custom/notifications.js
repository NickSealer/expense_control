document.addEventListener("turbo:load", function() {
  var protocol = location.protocol;
  var host = location.host;
  var user = $('#current_user').val();

  $('#notification-bell').click(function () {
    var notification_content = $('.notification-content');
    if (notification_content.css('display') === 'none') {
      notification_content.css('display', 'block');
    } else {
      notification_content.css('display', 'none');
    }
  })

  // GET read notification
  $('.notification-url-js').click(function() {
    var id = $(this).attr('data-id');
    var url = "/notifications/" + id + "/read" ;

    fetch(protocol + "//" + host + url)
    .then(res => {
      console.log('response: ', res);
    })
    .catch(error => {
      console.log(error);
    })
  });

// UPDATE or DELETE notification
  // $('.notification-option-js').click(function() {
  //   var id = $(this).attr('data-id');
  //   var action = $(this).attr('data-action');
  //   var url = "/notifications/" + id + "?user=" + user ;
  //   var method = ''; 
    
  //   if (action === 'update') {
  //     method = 'PUT';
  //   } else if (action === 'delete') {
  //     method = 'DELETE'
  //   } else {
  //     method = 'nil'
  //   }

  //   console.log(id, action, method)

  //   fetch(protocol + "//" + host + url, { method: method })
  //   .then(res => res.json())
  //   .then(data => {
  //     console.log("response: ", data);
  //   })
  //   .catch(error => {
  //     console.log(error);
  //   })
  // })

});
