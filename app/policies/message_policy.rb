class MessagePolicy < ApplicationPolicy
  def create?
    if record.sender.instance_of?(User)
      record.sender == user
    else
      record.sender.owner == user
    end
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
