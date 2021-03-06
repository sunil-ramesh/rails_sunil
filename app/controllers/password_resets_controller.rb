class PasswordResetsController < ApplicationController
  # def new
  # end
   before_action :get_user,   only: [:edit, :update]
    before_action :valid_user, only: [:edit, :update]
    	
  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to  root_path
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  # def edit
  # end

 
  
  def edit
  	
  end

  def update
  	
    if params[:user][:password].empty?                  # Case (3)
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update_attributes(user_params)          # Case (4)
      # log_in @user

      flash[:success] = "Password has been reset."
      redirect_to new_login_path
    else
      render 'edit'                                     # Case (2)
    end
  end
  def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    

  private

    def get_user
      @user = User.find_by(email: params[:email])
    end

    # Confirms a valid user.
    def valid_user
      if (@user && @user.activated? &&
              @user.authenticated?(:reset, params[:id]))
        redirect_to edit_password_reset_path
      end
    end
end
