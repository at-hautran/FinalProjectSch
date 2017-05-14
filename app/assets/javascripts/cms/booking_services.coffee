$ ->
  $('.get_link').click (ev) ->
    # ev.preventDefault();
    # console.log($(@).closest('.b').find('.number').val())
    booking_id = $(@).closest('.b').find('.booking_id').val()
    service_id = $(@).closest('.b').find('.service_id').val()
    number = $(@).closest('.b').find('.number').val()
    time = $(@).closest('.b').find('.time').val()
    $(@).attr("href", "/cms/bookings/#{booking_id}/create_services/#{service_id}?number=#{number}&time=#{time}&format=js")
    # bookings/:id/create_services/:service_id