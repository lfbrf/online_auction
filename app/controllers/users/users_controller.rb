class Users::UsersController < UsersController::Base
  before_action :authenticate_user!
  before_action :admin_only, :except => :show

  def index
    @users = User.all
  end

  def create
    if User.exists?( email: @invitation.recipient_email )
        redirect_to users_path, :alert => "Unable to register user."
    else
      render new_scoreboard_invitation_path
    end  
  end

  def show
    @user = User.find(params[:id])
    unless current_user.admin?
      unless @user == current_user
        redirect_to root_path, :alert => "Bem vindo."
      end
    end
  end


  def update
    @user = User.find(params[:id])
    if @user.update_attributes(secure_params)
      redirect_to users_path, :notice => "User updated."
    else
      redirect_to users_path, :alert => "Unable to update user."
    end
  end
 
  def destroy
    user = User.find(params[:id])
    user.destroy
    redirect_to users_path, :notice => "User deleted."
  end

  private

  def admin_only
    unless current_user.admin?
      redirect_to root_path, :alert => "Acesso Negado."
    end
  end

  def secure_params
    params.require(:user).permit(:role)
  end

end