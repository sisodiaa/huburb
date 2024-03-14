# Model for Membership
class Membership < ApplicationRecord
  belongs_to :room
  belongs_to :memberable, polymorphic: true

  validate :memberable_is_not_nil
  validate :check_users, if: :memberable_type_user?
  validate :check_pages, if: :memberable_type_page?

  private

  def memberable_is_not_nil
    errors.add(:memberable_nil, 'Member is not allowed to be nil') if memberable.nil?
  end

  def check_users
    errors.add(:member_user, 'Only one user is allowed per room') if room.users.count > 0
  end

  def check_pages
    errors.add(:member_page, 'Only one page is allowed per room') if room.pages.count > 0
  end

  def memberable_type_user?
    memberable_type == 'User'
  end

  def memberable_type_page?
    memberable_type == 'Page'
  end
end
