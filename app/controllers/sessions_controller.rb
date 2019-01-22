class SessionsController < ApplicationController
  def new
  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)
  	if user && user.authenticate(params[:session][:password])
  		log_in user
  		redirect_to user #redirect_to user_url(user)と同義, users/user.id
  	else
  		flash.now[:danger] = 'Invalid email/password combination'#nowは新規リクエストが来た時に消滅
  		render 'new'
  	end
  end

  def destroy
  	log_out
  	redirect_to root_url
  end
end
