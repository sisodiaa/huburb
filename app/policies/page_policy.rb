class PagePolicy < ApplicationPolicy
  def update?
    page_owner_is_current_user?
  end
  
  def edit?
    page_owner_is_current_user?
  end

  def destroy?
    page_owner_is_current_user?
  end

  def for_post
    page_owner_is_current_user?
  end

  def for_picture
    page_owner_is_current_user?
  end

  def for_advertisement
    page_owner_is_current_user?
  end

  def for_address
    page_owner_is_current_user?
  end
  
  def for_chat
    page_owner_is_current_user?
  end

  private

  def page_owner_is_current_user?
    record.owner == user
  end
end
