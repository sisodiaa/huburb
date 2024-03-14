document.addEventListener("turbolinks:load", function() {
  if(document.body.id == 'posts_edit' || document.body.id == 'posts_new') {
    document.addEventListener('trix-initialize', function(e) {
      trix = e.target;
			toolBar = trix.toolbarElement;

      if(!document.getElementById('add_image_button')) {
        // Creation of the button
        var button = document.createElement("button");
        button.setAttribute("type", "button");
        button.setAttribute("id", "add_image_button");
        button.innerText = "Insert Image by URL";

        var span = document.createElement('span');
        span.setAttribute('class', 'button_group');

        // Attachment of the button to the toolBar
        var addImageButton = toolBar.querySelector('.button_row').appendChild(span).appendChild(button);

        var input = document.createElement('input');
        input.setAttribute('type', 'url');
        input.setAttribute('placeholder', 'Enter a URL..');
        input.setAttribute('name', 'image_href');
        input.setAttribute('id', 'image_input');
        input.setAttribute('autofocus', true);

        var buttonGroup = document.createElement('div');
        buttonGroup.setAttribute('class', 'button_group');

        var insertButton = document.createElement('input');
        insertButton.setAttribute('type', 'button');
        insertButton.setAttribute('value', 'Insert');

        var linkURLFields = document.createElement('div');
        linkURLFields.setAttribute('class', 'link_url_fields');

        var div = document.createElement('div');
        div.setAttribute('class', 'dialog link_dialog');
        div.setAttribute('id', 'image_dialog');
        div.setAttribute('data-trix-attribute', 'href');
        div.setAttribute('data-trix-dialog', 'href');

        var active = false;

        var popup = toolBar.querySelector('.dialogs').appendChild(div).appendChild(linkURLFields);
        popup.appendChild(input);
        popup.appendChild(buttonGroup).appendChild(insertButton).addEventListener('click', function() {
          var url = document.getElementById('image_input').value;
          attributes = { url: url, contentType: "image" };
          var attachment = new Trix.Attachment(attributes);
          document.querySelector("trix-editor").editor.insertAttachment(attachment);
          document.getElementById('image_input').value = '';
          active = false;
        });

        var imageInput = document.getElementById('image_input');

        addImageButton.addEventListener('click', function() {
          if(!active) {
            toolBar.querySelector('#image_dialog').setAttribute('class', 'dialog link_dialog active');
            imageInput.removeAttribute('disabled');
            imageInput.focus();
            active = true;
          } else {
            toolBar.querySelector('#image_dialog').setAttribute('class', 'dialog link_dialog');
            active = false;
          }
        });

        imageInput.addEventListener("blur", function(e) {
          active = false;
        });
      }
    });
  }
});
