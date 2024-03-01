module Api
  module Users
    class RegistrationsController < Api::BaseController
      def create
        user = User.new(user_params)

        unless user_params[:email].present? && user_params[:email].match?(URI::MailTo::EMAIL_REGEXP)
          return base_render_unprocessable_entity({ email: ['Invalid email address.'] })
        end

        unless user_params[:password].length >= 8
          return base_render_unprocessable_entity({ password: ['Password must be at least 8 characters long.'] })
        end

        if user.save
          render 'api/users/create', locals: { user: user }, status: :created
        else
          base_render_unprocessable_entity(user.errors)
        end
      end

      private

      def user_params
        params.require(:user).permit(:email, :password)
      end
    end
  end
end
