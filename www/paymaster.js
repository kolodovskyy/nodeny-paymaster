(function() {
  var nodenyPaymaster;

  nodenyPaymaster = {
    checkForm: function(form) {
      var amount;
      amount = $(form).find('input[name="LMI_PAYMENT_AMOUNT"]').val();
      if (!amount.match(/^\d+(\.\d{1,2})*$/)) {
        return false;
      }
      if (!(amount > 0 && amount < 10000)) {
        return false;
      }
      return form.submit();
    }
  };

  $(document).ready(function() {
    $("form#lmi_form").submit(function(event) {
      event.preventDefault();
      return nodenyPaymaster.checkForm(this);
    });
    return $("form#lmi_form").find('input[type="submit"]').removeAttr('disabled');
  });

}).call(this);
