document.addEventListener("turbo:load", function() {
  $(function(){
    $('#expense-table').DataTable({
      ordering: false
    });

    if ($('.custom-file-label').length) {
      $('input[type="file"]').change(function(e){
        var fileName = e.target.files[0].name;
        $('.custom-file-label').text(fileName);
      });
    };

    $('#search_category').on("keyup", function(){
      if ($('#search_category').val().length > 1) {
        search_category();
      }
    });

    function search_category(){
      var protocol = location.protocol;
      var host = location.host;
      var user = $('#current_user').val();
      var url = "/api/v1/categories/search/?user=" + user + "&&query=";

      fetch(protocol + "//" + host + url + $('#search_category').val())
      .then(res => res.json())
      .then(data => {
        let categories = data.data
        $('#expense_category_id').empty();
        if (categories.length > 0) {
          categories.forEach((category, i) => {
            $('#expense_category_id').append('<option value="' + category.id + '">' + category.name + '</option>');
          });
          $('#expense_category_id').removeAttr('disabled');
          $('#div_for_select').css('display', 'block');
        } else {
          $('#expense_category_id').attr('disabled', 'true');
          $('#expense_category_id').append('<option>No results</option>');
          console.log("no data");
        }
      })
      .catch(error => {
        console.log("An error has ocurred.");
      })
    }

  });
});
