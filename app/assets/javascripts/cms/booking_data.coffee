$ ->
  $('.modalpop').click ->
    $('#update-bookings').attr('action', '/cms/bookings/'.concat($(@).find('.id').val()));
    $('.pop_customer_name').val($(@).find('.customer_name').val())
    $('.pop_customer_phone').val($(@).find('.customer_phone').val())
    $('.pop_customer_email').val($(@).find('.customer_email').val())
    $('.pop_customer_country').val($(@).find('.customer_country').val())
    $('.pop_room_name').val($(@).find('.room_name').val())
    $('.pop_check_in').val($(@).find('.check_in').val())
    $('.pop_check_out').val($(@).find('.check_out').val())
    $('.pop_status').val($(@).find('.status').val())
