module Api
  class UsersController < Api::BaseController
    before_action :doorkeeper_authorize!
    before_action :set_user, only: [:update]
    before_action :validate_user_params, only: [:update]

    def update
      authorize @user, policy_class: UserPolicy
      encrypted_password = User.encryptor.encrypt(user_params[:password]) if user_params[:password].present?
      update_service = Users::UpdateService.new(@user.id, user_params[:email], encrypted_password)
      if update_service.execute
        render json: { status: 200, user: update_service.user.as_json(only: [:id, :email, :updated_at]) }, status: :ok
      else
        render json: { message: 'Failed to update user profile.' }, status: :unprocessable_entity
      end
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.permit(:email, :password)
    end

    def validate_user_params
      render json: { message: "User ID must be an integer." }, status: :bad_request unless params[:id].to_i.to_s == params[:id]
      render json: { message: "Invalid email address." }, status: :bad_request if user_params[:email].present? && !user_params[:email].match?(/\A[^@\s]+@[^@\s]+\z/)
      render json: { message: "Password must be at least 8 characters long." }, status: :bad_request if user_params[:password].present? && user_params[:password].length < 8
    end
  end
end
