module ApplicationHelper
  def root_path
    if user_signed_in?
      authenticated_root_path
    else
      public_root_path
    end
  end

  def navbar_elements
    if user_signed_in?
      render partial: 'shared/authentic_user'
    else
      render partial: 'shared/unauthentic_user'
    end
  end

  def bootstrap_class_for flash_type
    { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type.to_sym] || flash_type.to_s
  end

  def flash_messages(opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)} alert-dismissible", role: 'alert') do
        concat(content_tag(:button, class: 'close', data: { dismiss: 'alert' }) do
          concat content_tag(:span, '&times;'.html_safe, 'aria-hidden' => true)
          concat content_tag(:span, 'Close', class: 'sr-only')
        end)
        concat message
      end)
    end
    nil
  end

  def error_message(klass, field)
    case field
      when :base
        content_tag(:small, klass.errors[:base].to_sentence, class: 'help-block')
      else
        content_tag(:small, field.to_s.titleize + ' ' + klass.errors[field].to_sentence, class: 'help-block')
    end
  end

  def error_present?(klass, field)
    klass.errors[field].present?
  end
end
