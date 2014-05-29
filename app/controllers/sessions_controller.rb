class SessionsController < ApplicationController
	before_action :signed_in_user, except: :destroy

  def new
  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)
  	if user and user.authenticate(params[:session][:password])
			confirmation_code = User.build_confirmation_code
			
			# TODO: Enviar SMS
			puts confirmation_code

			user.update_attribute(:confirmation_code, Digest::SHA256.hexdigest(confirmation_code))
			user.update_attribute(:sent_at, Time.now)

			pre_sign_in(user)

			render 'confirm'
  	else
  		flash[:alert] = "Email o contraseña inválidos"
  		render 'new'
  	end
  end

  def confirm
  end

  def validate
  	user = User.find(session[:user_id])
  	
  	if user and user.confirmation_code == Digest::SHA256.hexdigest(params[:session][:confirmation_code])
  		if (Time.now - user.sent_at) > 2.minutes
  			redirect_to root_url, alert: "El código de confirmación ha expirado. Por favor ingrese nuevamente."
  			return
  		end

  		sign_in(user)
  		session[:user_id] = nil
  		redirect_to root_url, notice: "Ha iniciado sesión correctamente"
  	else
   		flash[:alert] = "El código de confirmación no es válido, intente nuevamente."
  		render 'confirm' 		
  	end
  end

  def destroy
  	sign_out
    redirect_to root_url
  end
end
