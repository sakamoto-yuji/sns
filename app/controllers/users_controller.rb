class UsersController < ApplicationController
  def index
    @users = User.all.order(created_at: :desc)
  end

  def show
    @user = User.find_by(id:params[:id])
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
    if @user.save

      if @user.image_name.present?
        image = params[:image]
        File.binwrite("public/user_images/#{@user.id}.jpg",image.read)
        @user.image_name = "#{@user.id}.jpg"
        @user.save
      else
        @user.image_name = "default_image.jpg"
        @user.save
      end

      flash[:notice] = "アカウントを作成しました"
      redirect_to("/users/#{@user.id}")
     else
      render("users/new")
     end
  end

  def edit
  @user = User.find_by(id: params[:id])
  end

  def update
  @user = User.find_by(id: params[:id])
  @user.name = params[:name]
  @user.email = params[:email]
  if image = params[:image]
    File.binwrite("public/user_images/#{@user.image_name}",image.read)
  end
  if @user.save
    flash[:notice] = "アカウント情報を編集しました"
    redirect_to("/users/#{@user.id}")
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
    redirect_to("/users/index")
  end

  def login_form
  end

  def login
    @user = User.find_by(email: params[:email],
                         password: params[:password])
    if @user
      flash[:notice] = "ログインしました"
      redirect_to("/posts/index")
    else
      render("users/login_form")
    end
  end
end
