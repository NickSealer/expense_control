document.addEventListener("turbo:load", function() {
  var orginal_revenue_rows = $('.revenue-row').length;
  var orginal_charge_rows = $('.charge-row').length;

  $('.js-add-revenue').click((event) => {
    var qty = $('.revenue-row').length;
    var copy = `<div class="form-row revenue-row">
                  <div class="form-group col-md-3">
                      <input class="form-control" placeholder="Value" required="required" type="text" name="budget[revenues_attributes][${qty}][value]" id="budget_revenues_attributes_${qty}_value">
                  </div>
                  <div class="form-group col-md-5">
                      <input class="form-control" placeholder="Concept" required="required" type="text" name="budget[revenues_attributes][${qty}][concept]" id="budget_revenues_attributes_${qty}_concept">
                  </div>
                  <div class="form-group col-md-3">
                    <div class="input-group mb-3">
                      <div class="input-group-prepend">
                        <label class="input-group-text">Type</label>
                      </div>
                      <select class="custom-select" name="budget[revenues_attributes][${qty}][category]" id="budget_revenues_attributes_${qty}_category">
                        <option selected="selected" value="fixed">fixed</option>
                        <option value="variable">variable</option>
                      </select>
                    </div>
                  </div>
                  <div class="form-group col-md-1" style="color: white;">
                    Delete: <input name="budget[revenues_attributes][${qty}][_destroy]" type="hidden" value="0"><input type="checkbox" value="1" name="budget[revenues_attributes][${qty}][_destroy]" id="budget_revenues_attributes_${qty}__destroy">
                  </div>
                </div>`;

    $('.revenue-row').last().after(copy);
  });

  $('.js-add-charge').click((event)=> {
    var qty = $('.charge-row').length;
    var copy = `<div class="form-row charge-row">
                  <div class="form-group col-md-3">
                      <input class="form-control" placeholder="Value" required="required" type="text" name="budget[charges_attributes][${qty}][value]" id="budget_charges_attributes_${qty}_value">
                  </div>
                  <div class="form-group col-md-5">
                      <input class="form-control" placeholder="Concept" required="required" type="text" name="budget[charges_attributes][${qty}][concept]" id="budget_charges_attributes_${qty}_concept">
                  </div>
                  <div class="form-group col-md-3">
                    <div class="input-group mb-3">
                      <div class="input-group-prepend">
                        <label class="input-group-text">Type</label>
                      </div>
                      <select class="custom-select" name="budget[charges_attributes][${qty}][category]" id="budget_charges_attributes_${qty}_category">
                        <option selected="selected" value="fixed">fixed</option>
                        <option value="variable">variable</option>
                      </select>
                    </div>
                  </div>
                  <div class="form-group col-md-1" style="color: white;">
                    Delete: <input name="budget[charges_attributes][${qty}][_destroy]" type="hidden" value="0"><input type="checkbox" value="1" name="budget[charges_attributes][${qty}][_destroy]" id="budget_charges_attributes_${qty}__destroy">
                  </div>
                </div>`;

    $('.charge-row').last().after(copy);
  });

  $('.js-remove-revenue').click((event) => {
    if ($('.revenue-row').length > orginal_revenue_rows) {
      $('.revenue-row').last().remove();
    }
  });

  $('.js-remove-charge').click((event) => {
    if ($('.charge-row').length > orginal_charge_rows) {
      $('.charge-row').last().remove();
    }
  });
});
