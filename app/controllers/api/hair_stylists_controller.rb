module Api
  class HairStylistsController < BaseController
    rescue_from ActiveRecord::RecordNotFound, with: :base_render_record_not_found

    def index
      hair_stylist_service = HairStylistsService::Index.new(params[:id])
      result = hair_stylist_service.execute(page: params[:page], per_page: params[:per_page])
      render json: result, status: :ok
    end

    def treatment_plan_requests
      stylist_id = params[:stylist_id].to_i
      return render json: { message: "Stylist ID must be an integer." }, status: :bad_request unless stylist_id.is_a?(Integer)

      hair_stylist = HairStylist.find_by(id: stylist_id)
      return render json: { message: "Hair stylist not found." }, status: :not_found if hair_stylist.nil?

      authorize hair_stylist, policy_class: HairStylistPolicy # Assuming HairStylistPolicy exists

      service = HairStylistsService::Index.new(hair_stylist.id)
      result = service.execute # No need for pagination parameters in this case

      render 'api/hair_stylists/treatment_plan_requests', locals: { treatment_plan_requests: result[:requests] }, status: :ok
    rescue Pundit::NotAuthorizedError
      render json: { message: I18n.t('common.errors.unauthorized_error') }, status: :forbidden
    end
  end
end
