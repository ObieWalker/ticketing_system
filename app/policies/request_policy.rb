class RequestPolicy < ApplicationPolicy
  class Scope < Scope
  
    attr_reader :user, :scope

    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      if user.role == 0 || user.role == 1
        scope.all
      else
        scope.where(user_id: user.id)
      end
    end
  end

  def update?
    user.role == 0 or user.role == 1
  end
end