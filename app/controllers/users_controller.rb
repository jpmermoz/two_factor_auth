class UsersController < ApplicationController
  before_action :signed_in_user, except: :show

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to root_url, notice: 'Cuenta creada correctamente. Ahora puede iniciar sesión.' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :phone_number, :password, :password_confirmation)
  end

end
