class UserController < ApplicationController
  layout :choose_layout
  
  def choose_layout
    return 'login' if action_name == 'login' or action_name == 'set_new_password'
    return 'forgotpw' if action_name == 'forgot_password'
    return 'dashboard' if action_name == 'dashboard'
    'application'
  end
  
  def change_password
  end

  def create
  end

  def delete
  end

  def dashboard
  end

  def edit
  end

  def forgot_password
  end

  def login
  end

  def logout
  end

end
