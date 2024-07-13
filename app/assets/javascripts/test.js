$(document).ready(function() {
  function updateRevenue(partnerManagerIndex) {
    var $container = $('#partner_order_partner_managers_attributes_' + partnerManagerIndex + '_product_id').closest('fieldset');
    var productSold = parseFloat($container.find(".product_sold").val()) || 0;
    var productId = $container.find(".product_select").val();
    var fee = parseFloat($container.find(".fee").val()) || 0;

    if (productId) {
      $.ajax({
        url: '/api/v2/products/' + productId,
        method: 'GET',
        success: function(data) {
          var productPrice = data.price;
          var revenue = productSold * productPrice;
          $container.find(".revenue").val(revenue.toFixed(2));
          
          var payForPartner = revenue - fee;
          $container.find(".pay_for_partner").val(payForPartner.toFixed(2));
        },
        error: function() {
          $container.find(".revenue").val("0.00");
          $container.find(".pay_for_partner").val("0.00");
        }
      });
    } else {
      $container.find(".revenue").val("0.00");
      $container.find(".pay_for_partner").val("0.00");
    }
  }

  function addEventListeners() {
    $(document).on('change', '.quantity_entered, .product_sold, .product_select, .fee', function() {
      var partnerManagerIndex = $(this).closest('fieldset').find('.product_select').attr('id').match(/\d+/)[0];
      updateRevenue(partnerManagerIndex);
    });
  }

  addEventListeners();

  // Handle dynamically added partner managers
  $(document).on('has_many_add:after', '.has_many_container', function(e, fieldset) {
    var newIndex = fieldset.find('.product_select').attr('id').match(/\d+/)[0];
    addEventListeners();
    updateRevenue(newIndex);
  });
});
