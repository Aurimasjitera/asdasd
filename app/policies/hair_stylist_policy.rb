class HairStylistPolicy < ApplicationPolicy
  def treatment_plan_requests?
    user.is_a?(HairStylist) && record.id == user.id
  end
end
