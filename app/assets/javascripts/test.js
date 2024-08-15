$(document).ready(function() {

  function updateInventory(partnerManagerIndex) {
    var $container = $('#partner_order_partner_managers_attributes_' + partnerManagerIndex + '_product_id').closest('fieldset');
    var quantityEntered = parseFloat($container.find(".quantity_entered").val()) || 0;
    var productSold = parseFloat($container.find(".product_sold").val()) || 0;

    var inventory = quantityEntered - productSold;
    $container.find(".inventory").val(inventory);
  }

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

          updateTotalValues();
        },
        error: function() {
          $container.find(".revenue").val("0.00");
          $container.find(".pay_for_partner").val("0.00");

          updateTotalValues();
        }
      });
    } else {
      $container.find(".revenue").val("0.00");
      $container.find(".pay_for_partner").val("0.00");

      updateTotalValues();
    }
  }

  function updateTotalValues() {
    var totalFee = parseFloat($('.total_fee').val()) || 0;
    var totalSell = 0;
    var totalRevenue = 0;
    var totalPayForPartner = 0;
  
    $(".product_sold").each(function() {
      totalSell += parseFloat($(this).val()) || 0;
    });
  
    $(".revenue").each(function() {
      totalRevenue += parseFloat($(this).val()) || 0;
    });
  
    $(".pay_for_partner").each(function() {
      totalPayForPartner += parseFloat($(this).val()) || 0;
    });
    var feePercentage = totalFee / 100;
    var totalRevenueAfterFee = totalRevenue * (1 - feePercentage);
  
    $('.total_sell').val(totalSell.toFixed(2));
    $('.total_revenue').val(totalRevenue.toFixed(2));
    $('.total_pay_for_partner').val((totalRevenueAfterFee - totalFee).toFixed(2));
  }

  function addEventListeners() {
    $(document).on('change', '.quantity_entered, .product_sold, .product_select, .fee, #partner_order_fee', function() {
      var partnerManagerIndex = $(this).closest('fieldset').find('.product_select').attr('id').match(/\d+/)[0];
      updateInventory(partnerManagerIndex);
      updateRevenue(partnerManagerIndex);
    });
  }

  addEventListeners();

  // Handle dynamically added partner managers
  $(document).on('has_many_add:after', '.has_many_container', function(e, fieldset) {
    var newIndex = fieldset.find('.product_select').attr('id').match(/\d+/)[0];
    addEventListeners();
    updateInventory(newIndex);
    updateRevenue(newIndex);
  });
});
