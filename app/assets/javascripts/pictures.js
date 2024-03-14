// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

document.addEventListener("turbolinks:load", function() {
	if(document.body.id == 'profile_edit') {
		var thumb_source, vp;
		$('#profile-avatar-section input.btn-success[value=Upload]').prop("disabled", true);

		$('#avatar_picture').change(function() {
			if(this.files && this.files[0]) {
				$('#profile-avatar-overlay').fadeIn();

				var reader = new FileReader();
				var dataItem = this.files[0];
				reader.onload = function(e) {
					var url = e.target.result;
					var image = new Image();

					image.onload = function() {
						var avatarContainer = document.getElementById('avatar-container');
						var avatarContainerControls = Array.prototype.slice.call(avatarContainer.getElementsByTagName("a"));

						$(avatarContainer).empty();

						var aspectRatio = image.width / image.height; 
						image.height = window.innerHeight * 0.7;
						image.width = aspectRatio * image.height;

						var left = ((window.innerWidth / 2) - (image.width/2 - 8));
						var leftP = left / window.innerWidth * 100;
						$(avatarContainer).css({
							left: leftP + "%",
							width: image.width + 16
						});

						$(avatarContainer).append(image);
						$('#cropbox').Jcrop({
							aspectRatio: 1,
							setSelect: [0, 0, image.width, image.height],
							onSelect: handleCoords,
							onChange: handleCoords
						});

						thumb_source = image.src;
						$(avatarContainer).append($(avatarContainerControls));

						$('div#avatar-container a.btn-primary').click(function(e) {
							e.preventDefault();
							e.stopPropagation();
							$('#avatar_viewport_x').val(vp.x);
							$('#avatar_viewport_y').val(vp.y);
							$('#avatar_viewport_width').val(vp.w);
							$('#avatar_viewport_height').val(vp.h);
							$('#avatar_viewport_pic_w').val(image.width);
							$('#avatar_viewport_pic_h').val(image.height);
							$('#avatar-thumbnail > img').attr("src", thumb_source);
							$('#avatar-thumbnail > img').css({
								width: Math.round(200/vp.w * $('#cropbox').width()) + 'px',
								height: Math.round(200/vp.h * $('#cropbox').height()) + 'px',
								'margin-left': '-' + Math.round(200/vp.w * vp.x) + 'px',
								'margin-top': '-' + Math.round(200/vp.h * vp.y) + 'px'
							});
							$('#profile-avatar-overlay').fadeOut();
							$('#profile-avatar-section input.btn-success[value=Upload]').prop("disabled", false)
						});

						$('div#avatar-container a.btn-danger').click(function() {
							e.preventDefault();
							e.stopPropagation();
							$('#profile-avatar-overlay').fadeOut();
						});
					}

					image.id = "cropbox";
					image.src = url;
				}

				reader.readAsDataURL(dataItem);
			}
		});

		$('#profile-avatar-overlay').click(function(e) {
			if (e.target === this) { // Check that target of click is parent div
				$(this).fadeOut();
			}
		});

		$('#profile-avatar-section input.btn-success[value=Upload]').click(function(e) {
			e.preventDefault();
			e.stopPropagation();
			$('input.btn-danger').prop('disabled', true);
			$(this).prop('disabled', true);
			var avatarForm = document.getElementById('edit_avatar') || document.getElementById('new_avatar');
			var avatarFormData = new FormData(avatarForm);
			$.ajax({
				url: '/user/avatar',
				type: "POST",
				data: avatarFormData,
				processData: false,
				contentType: false,
				dataType: "script",
				context: this,
				success: function(response) {
					$(this).prop('disabled', false);
				},
				error: function(jqXHR, textStatus, errorMessage) {
					$(this).prop('disabled', false);
					$('input.btn-danger').prop('disabled', false);
				}
			});
		});

		function handleCoords(coords) {
			vp = coords;
		}
	}

	if(document.body.id == 'pages_edit') {
		var thumb_source, vp;
		$('#page-logo-section input.btn-success[value=Upload]').prop("disabled", true);

		$('#logo_picture').change(function() {
			if(this.files && this.files[0]) {
				$('#page-logo-overlay').fadeIn();

				var reader = new FileReader();
				var dataItem = this.files[0];
				reader.onload = function(e) {
					var url = e.target.result;
					var image = new Image();

					image.onload = function() {
						var logoContainer = document.getElementById('logo-container');
						var logoContainerControls = Array.prototype.slice.call(logoContainer.getElementsByTagName("a"));

						$(logoContainer).empty();

						var aspectRatio = image.width / image.height; 
						image.height = window.innerHeight * 0.7;
						image.width = aspectRatio * image.height;

						var left = ((window.innerWidth / 2) - (image.width/2 - 8));
						var leftP = left / window.innerWidth * 100;
						$(logoContainer).css({
							left: leftP + "%",
							width: image.width + 16
						});

						$(logoContainer).append(image);
						$('#cropbox').Jcrop({
							aspectRatio: 1,
							setSelect: [0, 0, image.width, image.height],
							onSelect: handleCoords,
							onChange: handleCoords
						});

						thumb_source = image.src;
						$(logoContainer).append($(logoContainerControls));

						$('div#logo-container a.btn-primary').click(function(e) {
							e.preventDefault();
							e.stopPropagation();
							$('#logo_viewport_x').val(vp.x);
							$('#logo_viewport_y').val(vp.y);
							$('#logo_viewport_width').val(vp.w);
							$('#logo_viewport_height').val(vp.h);
							$('#logo_viewport_pic_w').val(image.width);
							$('#logo_viewport_pic_h').val(image.height);
							$('#logo-thumbnail > img').attr("src", thumb_source);
							$('#logo-thumbnail > img').css({
								width: Math.round(200/vp.w * $('#cropbox').width()) + 'px',
								height: Math.round(200/vp.h * $('#cropbox').height()) + 'px',
								'margin-left': '-' + Math.round(200/vp.w * vp.x) + 'px',
								'margin-top': '-' + Math.round(200/vp.h * vp.y) + 'px'
							});
							$('#page-logo-overlay').fadeOut();
							$('#page-logo-section input.btn-success[value=Upload]').prop("disabled", false)
						});

						$('div#logo-container a.btn-danger').click(function() {
							e.preventDefault();
							e.stopPropagation();
							$('#page-logo-overlay').fadeOut();
						});
					}

					image.id = "cropbox";
					image.src = url;
				}

				reader.readAsDataURL(dataItem);
			}
		});

		$('#page-logo-overlay').click(function(e) {
			if (e.target === this) { // Check that target of click is parent div
				$(this).fadeOut();
			}
		});

		$('#page-logo-section input.btn-success[value=Upload]').click(function(e) {
			e.preventDefault();
			e.stopPropagation();
			$('input.btn-danger').prop('disabled', true);
			$(this).prop('disabled', true);
			var pin = $(this).data('pin');
			var logoForm = document.getElementById('edit_logo') || document.getElementById('new_logo');
			var logoFormData = new FormData(logoForm);
			$.ajax({
				url: '/pages/' + pin + '/logo',
				type: "POST",
				data: logoFormData,
				processData: false,
				contentType: false,
				dataType: "script",
				context: this,
				success: function(response) {
					$(this).prop('disabled', false);
				},
				error: function(jqXHR, textStatus, errorMessage) {
					$(this).prop('disabled', false);
					$('input.btn-danger').prop('disabled', false);
				}
			});
		});

		function handleCoords(coords) {
			vp = coords;
		}
	}
});
