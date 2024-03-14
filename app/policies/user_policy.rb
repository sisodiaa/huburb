class UserPolicy < ApplicationPolicy
  def for_address
    record == user
  end
end
