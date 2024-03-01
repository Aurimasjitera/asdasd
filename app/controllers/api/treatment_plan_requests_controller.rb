module Api
  class TreatmentPlanRequestsController < BaseController
    before_action :doorkeeper_authorize!

    def create
      user_id = params[:user_id]
      area = params[:area]

      return base_render_unprocessable_entity("User ID must be an integer.") unless user_id.is_a?(Integer)
      return base_render_unprocessable_entity("Area is required.") if area.blank?

      user = User.find_by(id: user_id)
      return base_render_unprocessable_entity("User not found.") if user.nil?

      treatment_plan_request = TreatmentPlanRequest.create!(user_id: user.id, area: area, status: 'pending')
      render 'api/treatment_plan_requests/create', locals: { treatment_plan_request: treatment_plan_request }, status: :created
    rescue ActiveRecord::RecordInvalid => e
      base_render_unprocessable_entity(e)
    end
  end
end
