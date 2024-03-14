class RoomPolicy < ApplicationPolicy
  def index?
    current_user_owner_of_page?
  end

  def show?
    record.users.include?(user) || current_user_owner_of_page?
  end

  private

  def current_user_owner_of_page?
    record.pages.first.owner == user
  end
end
