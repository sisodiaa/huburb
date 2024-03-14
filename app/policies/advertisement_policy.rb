class AdvertisementPolicy < ApplicationPolicy
  def index?
    record && record.first.page.owner == user
  end

  def show?
    advertisement_owner_is_current_user?
  end

  def new?
    advertisement_owner_is_current_user?
  end

  def create?
    advertisement_owner_is_current_user?
  end

  def edit?
    advertisement_owner_is_current_user?
  end

  def update?
    advertisement_owner_is_current_user?
  end

  def destroy?
    advertisement_owner_is_current_user?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end

  private

  def advertisement_owner_is_current_user?
    record.page.owner == user
  end
end
