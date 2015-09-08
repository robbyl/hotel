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
    #    @config = Configuration.available_modules

    @user = User.new(params[:user])
    if request.post?
      if @user.save
        flash[:notice] = "#{t('flash17')}"
        redirect_to :controller => 'user', :action => 'edit', :id => @user.username
      else
        flash[:notice] = "#{t('flash16')}"
      end
    end
  end

  def delete
  end

  def dashboard
    @user = current_user
#    @config = Configuration.available_modules
#    @employee = @user.employee_record if ["#{t('admin')}","#{t('employee_text')}"].include?(@user.role_name)
#    if @user.student?
#      @student = Student.find_by_admission_no(@user.username)
#    end
#    if @user.parent?
#      @student = Student.find_by_admission_no(@user.username[1..@user.username.length])
#    end
#    @first_time_login = Configuration.get_config_value('FirstTimeLoginEnable')
#    if  session[:user_id].present? and @first_time_login == "1" and @user.is_first_login != false
#      flash[:notice] = "#{t('first_login_attempt')}"
#      redirect_to :controller => "user",:action => "first_login_change_password",:id => @user.username
#    end
  end

  def edit
  end

  def forgot_password
  end

  def login
    #    @institute = Configuration.find_by_config_key("LogoName")
    #    available_login_authes = FedenaPlugin::AVAILABLE_MODULES.select{|m| m[:name].classify.constantize.respond_to?("login_hook")}
    #    selected_login_hook = available_login_authes.first if available_login_authes.count>=1
    #    if selected_login_hook
    #      authenticated_user = selected_login_hook[:name].classify.constantize.send("login_hook",self)
    #    else
    if request.post? and params[:user]
      @user = User.new(params[:user])
      user = User.active.find_by_username @user.username
      if user.present? and User.authenticate?(@user.username, @user.password)
        authenticated_user = user
      end
    end
    #    end
    if authenticated_user.present?
      successful_user_login(authenticated_user) and return
    elsif authenticated_user.blank? and request.post?
      flash[:notice] = "#{t('login_error_message')}"
    end
  end

  def logout
    Rails.cache.delete("user_main_menu#{session[:user_id]}")
    Rails.cache.delete("user_autocomplete_menu#{session[:user_id]}")
    session[:user_id] = nil
    session[:language] = nil
    flash[:notice] = "#{t('logged_out')}"
    #    available_login_authes = FedenaPlugin::AVAILABLE_MODULES.select{|m| m[:name].classify.constantize.respond_to?("logout_hook")}
    #    selected_logout_hook = available_login_authes.first if available_login_authes.count>=1
    #    if selected_logout_hook
    #      selected_logout_hook[:name].classify.constantize.send("logout_hook",self,"/")
    #    else
    redirect_to :controller => 'user', :action => 'login' and return
    #    end
  end
  
  private
  def successful_user_login(user)
    session[:user_id] = user.id
    flash[:notice] = "#{t('welcome')}, #{user.first_name} #{user.last_name}!"
    redirect_to session[:back_url] || {:controller => 'user', :action => 'dashboard'}
  end

end
