/*!
 * Start Bootstrap - Creative Bootstrap Theme (http://startbootstrap.com)
 * Code licensed under the Apache License v2.0.
 * For details, see http://www.apache.org/licenses/LICENSE-2.0.
 */

$(document).ready(function(){

  (function($) {
      "use strict"; // Start of use strict

      // jQuery for page scrolling feature - requires jQuery Easing plugin
      $('#homepage a.page-scroll').bind('click', function(event) {
					var $anchor = $(this);
          $('html, body').stop().animate({
              scrollTop: ($($anchor.attr('href')).offset().top - 50)
          }, 1250, 'easeInOutExpo');
          event.preventDefault();
      });

      // Highlight the top nav as scrolling occurs
      $('body#homepage').scrollspy({
          target: '.navbar-fixed-top',
          offset: 51
      })

      // Closes the Responsive Menu on Menu Item Click
      $('#homepage .navbar-collapse ul li a').click(function() {
          $('.navbar-toggle:visible').click();
      });

			$("a.cta-link").on('click', function(e) {
					e.preventDefault();
					e.stopPropagation();
					$("#invitee-popup-overlay").fadeIn();
					$('.has-error').each(function() {
							$(this).removeClass('has-error');
					});
					$('small.help-block').remove();
			});

			$('#invitee-popup-overlay').click(function(e) {
					if (e.target === this) { // Check that target of click is parent div
							$(this).fadeOut();
					}
			});

			$("#invitee-popup > div.text-center").click(function(e) {
					e.preventDefault();
					e.stopPropagation();
					$('#invitee-popup-overlay').fadeOut();
			});

      // Fit Text Plugin for Main Header
      $("#homepage h1").fitText(
          1.2, {
              minFontSize: '35px',
              maxFontSize: '65px'
          }
      );

      // Offset for Main Navigation
      $('#homepage #mainNav').affix({
          offset: {
              top: 100
          }
      })

      // Initialize WOW.js Scrolling Animations
      new WOW().init();

  })(jQuery); // End of use strict

})

