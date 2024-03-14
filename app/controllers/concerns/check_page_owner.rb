module CheckPageOwner
  extend ActiveSupport::Concern

  included do
    before_action :check_page_owner, only: %i[new create edit update destroy]
  end

  private

  def check_page_owner
    @page ||= nil
    throw(:abort) unless @page.nil? || @page.owner == current_user
  rescue
    redirect_to authenticated_root_path
  end
end
