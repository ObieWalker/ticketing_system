class CommentPolicy < ApplicationPolicy
  def update?
    user.id == record.user_id
  end

  def destroy?
    user.id == record.user_id or user.role == 0 or user.role == 1
  end
end