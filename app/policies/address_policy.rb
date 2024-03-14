class AddressPolicy < ApplicationPolicy
  def create?
    record.new_record? && check_owner_user?
  end

  def update?
    check_owner_user?
  end

  def edit?
    check_owner_user?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end

  private

  def check_owner_user?
    if record.locatable.instance_of?(User)
      record.locatable == user
    else
      record.locatable.owner == user
    end
  end
end
