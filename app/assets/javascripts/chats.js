document.addEventListener("turbolinks:load", function() {
  $('#button-create-room').click(function(e) {
    $(document.body).append($('#button-create-room').parent());
    $('.chat-panel-create-room-form').remove();
    $('.sk-fading-circle').removeClass('spinner-hidden');
    $('#button-create-room').hide();
  });

  $('.room-list > a').click(function(e) {
    $('#chat-rooms-list').remove();
    $('.sk-fading-circle').removeClass('spinner-hidden');
  });

	if(document.getElementById('chat-panel-messages')) {
		var chat_room_id = $('#chat-panel-messages').data('chat-room');
		if(!App["chat_room_" + chat_room_id]) {
			createChatRoomSubscription(chat_room_id);
		}
  }
});
