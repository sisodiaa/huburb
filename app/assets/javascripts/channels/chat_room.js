function createChatRoomSubscription(chat_room_id) {
	App["chat_room_" + chat_room_id] = App.cable.subscriptions.create({
		channel: "ChatRoomChannel",
		room_id: chat_room_id
	}, 
	{
		connected: function() {
		},

		disconnected: function() {
      console.log('Connection disconnected');
      this.unsubscribe();
		},

    received: function(data) {
      $('.has-error').each(function() {
        $(this).removeClass('has-error');
      });
      $('small.help-block').remove();
      clearAlerts();

      $('textarea#message_content').val('');
      var message = '';
      if (data['sender_type'] == $('#chat-panel-messages').data('sender')) {
        message =  data['message'].replace(/message-card /, 'message-card sender');
      } else {
        message = data['message'];
      }
			$("#chat-panel-messages[data-chat-room="+chat_room_id+"]").append(message);
      $("div#chat-panel-messages[data-chat-room="+chat_room_id+"]")
        .animate({scrollTop: $('div#chat-panel-messages').prop('scrollHeight')}, 500);
		}
	});
}
