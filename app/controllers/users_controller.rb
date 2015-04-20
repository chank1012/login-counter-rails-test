class UsersController < ApplicationController
  protect_from_forgery with: :exception
  include UsersHelper
  skip_before_filter :verify_authenticity_token
  
  def index
  end
  
  def login
    @user = User.find_by(username: params[:username])

    if @user && @user.authenticate(params[:password])
      @user.password = params[:password]
      @user.counter += 1
      @user.save
      log_in @user
      render :json => { user_name: params[:username], login_count: @user.counter }
    else
      render :json => { error_code: -4 }
    end
  end
  
  def signup
    @user = User.new(user_params)
    @user.counter = 1
    if @user.save
      log_in @user
      render :json => { user_name: params[:username], login_count: @user.counter }
    else
      error_flag = [false, false, false]
      
      if @user.errors.include?(:username)
        @user.errors.get(:username).each do |e|
          error_flag[0] = true if e.include? 'is too'
          error_flag[2] = true if e.include? 'already been taken'
        end
      end
      
      if @user.errors.include?(:password)
        error_flag[1] = true
      end
      
      render :json => { error_code: -1 } and return if error_flag[0]
      render :json => { error_code: -2 } and return if error_flag[1]
      render :json => { error_code: -3 } and return if error_flag[2]
      render :json => { error_code: -5 }
    end
  end
  
  def logout
    log_out
    redirect_to root_path
  end
  
  def clear_data
    User.delete_all
    redirect_to root_path
  end

  def user_count
    render :json => { user_count: User.all.count }
  end
  
  def user_params
    params.permit(:username, :password)
  end
  
  def user_params_with(counter)
    params[:counter] = counter
    params.permit(:username, :password, :counter)
  end
end
