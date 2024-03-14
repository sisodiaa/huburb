class Users::ConfirmationsController < Devise::ConfirmationsController
  # GET /resource/confirmation/new
  # def new
  #   super
  # end

  # POST /resource/confirmation
  def create
    self.resource = resource_class.send_confirmation_instructions(resource_params)

    if successfully_sent?(resource)
      set_flash_message :notice, :send_instructions
      respond_to do |format|
        format.html do
          respond_with({}, location: after_resending_confirmation_instructions_path)
        end
        format.js
      end
    else
      render :new
    end
  end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    super do
      unless resource.errors.empty?
        flash.now[:error] = resource.errors.full_messages.join(" ")
      end
    end
  end

  # protected

  # The path used after resending confirmation instructions.
  def after_resending_confirmation_instructions_path
    new_user_session_path
  end

  # The path used after confirmation.
  # def after_confirmation_path_for(resource_name, resource)
  #   super(resource_name, resource)
  # end
end
