require_relative '../../models/user'

module Users
  class UpdateService
    def initialize(user_id, email, password_hash)
      @user_id = user_id
      @new_email = email
      @new_password_hash = password_hash
    end

    def execute
      user = User.find_by(id: @user_id)
      raise ActiveRecord::RecordNotFound.new("User not found") if user.nil?

      validate_email!
      validate_password_hash!

      user.email = @new_email
      user.password_hash = @new_password_hash
      user.updated_at = Time.current

      if user.save
        { id: user.id, email: user.email, updated_at: user.updated_at }
      else
        raise ActiveRecord::RecordInvalid.new(user)
      end
    end

    private

    def validate_email!
      if @new_email.blank? || !@new_email.match?(URI::MailTo::EMAIL_REGEXP) || User.exists?(email: @new_email)
        raise ActiveRecord::RecordInvalid.new("Validation failed: Email #{@new_email} is invalid or already taken")
      end
    end

    def validate_password_hash!
      raise ActiveRecord::RecordInvalid.new("Validation failed: Password hash can't be blank") if @new_password_hash.blank?
    end
  end
end
