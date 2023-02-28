class UsersController < ApplicationController
  before_action :authenticate_user!,{only:[:index,:show,:edit,:update]}
  #  before_action :forbid_login_user,{only:[:new,:create,:login_form,:login]}
  #  before_action :ensure_correct_user,{only:[:edit,:update,:destroy]}

  def ensure_correct_user
    if current_user.id != params[:id].to_i
      flash[:notice] = "権限がありません"
      redirect_to(posts_path)
    end
  end

  def index
    @users = User.all.order(created_at: :desc)
  end

  def show
    @user = User.find_by(id: params[:id])
    @likes = current_user.likes.includes(:post)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(
      name: params[:name],
      email: params[:email],
      image_name: params[:image],
      password: params[:password]
    ) 
    if @user.save(context: :registration)
      session[:user_id] = @user.id

      if @user.image_name
        @user.image_name = "#{@user.id}.jpg"
        image = params[:image]
        File.binwrite("public/user_images/#{@user.image_name}",image.read)
        @user.save
      else
        @user.image_name = "default_image.jpg"
        @user.save
      end

      flash[:notice] = "アカウントを作成しました"
      redirect_to("/users/#{@user.id}")
    else
      render(new_user_path)
    end
  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: update_params[:id])
    @user.name = update_params[:name]
    @user.email = update_params[:email]
    if image = update_params[:image]
      File.binwrite("public/user_images/#{@user.id}.jpg",image.read)
      @user.image_name = "#{@user.id}.jpg"
    end
    if @user.save
      flash[:notice] = "アカウント情報を編集しました"
      redirect_to(user_path(id: @user.id))
    else
      render("users/edit")
    end
  end

  def destroy
    @user = User.find_by(id: params[:id])
    if @user.image_name == "default_image.jpg"

    else
      if File.exist?("public/user_images/#{@user.image_name}")
        File.delete("public/user_images/#{@user.image_name}")
      end

    end
    @user.destroy
    flash[:notice] = "アカウントを削除しました"
    redirect_to(root_path)
  end

  private

  def update_params
    params.permit(:id, :name, :email, :image)
  end

  def login_form
  end

  def login
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:notice] = "ログインしました"
      redirect_to(posts_path)
    else
      @error_message = "メールアドレスまたはパスワードが間違っています"

      if User.find_by(email: params[:email])
      else
        @wrong_email = "メールアドレスが間違っています"
      end

      if @user 
        if @user.authenticate(params[:password])
        else
          @wrong_password = "パスワードが間違っています"
        end
      end


      @email = params[:email]
      @password = params[:password]
      render("users/login_form")
    end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = "ログアウトしました"
    redirect_to("/login")
  end

end
