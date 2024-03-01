# FILE PATH: /app/services/treatment_plan_request_service/create.rb
require_dependency 'app/models/user'
require_dependency 'app/models/treatment_plan_request'

module TreatmentPlanRequestService
  class Create < BaseService
    def initialize(user_id, area)
      @user_id = user_id
      @area = area
    end

    def call
      validate_presence_of_fields
      validate_user
      validate_area
      treatment_plan_request = create_treatment_plan_request
      success_response(treatment_plan_request)
    rescue ActiveRecord::RecordInvalid => e
      error_response(e)
    end

    private

    attr_reader :user_id, :area

    def validate_presence_of_fields
      raise ActiveRecord::RecordInvalid.new(User.new), I18n.t('activerecord.errors.messages.blank') if user_id.blank? || area.blank?
    end

    def validate_user
      user = User.find_by(id: user_id)
      raise ActiveRecord::RecordInvalid.new(user), I18n.t('activerecord.errors.messages.invalid') if user.nil? || user.customer?
    end

    def validate_area
      raise ActiveRecord::RecordInvalid.new(TreatmentPlanRequest.new), I18n.t('activerecord.errors.messages.invalid') unless area.present? && area.is_a?(String)
    end

    def create_treatment_plan_request
      TreatmentPlanRequest.create!(
        user_id: user_id,
        area: area,
        status: 'pending', # Assuming 'pending' is the default status
        created_at: Time.current,
        updated_at: Time.current
      )
    end

    def success_response(treatment_plan_request)
      {
        id: treatment_plan_request.id,
        user_id: treatment_plan_request.user_id,
        area: treatment_plan_request.area,
        status: treatment_plan_request.status,
        created_at: treatment_plan_request.created_at,
        updated_at: treatment_plan_request.updated_at
      }
    end

    def error_response(exception)
      {
        success: false,
        message: exception.message,
        errors: exception.record.errors.full_messages
      }
    end
  end
end
