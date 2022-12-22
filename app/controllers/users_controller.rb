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
      image_name: "default_image.jpg"
      ) 
    if image = params[:image]
      @user.image_name = "#{@user.name}.jpg"
      File.binwrite("public/user_images/#{@user.image_name}",image.read)
    end
     if @user.save
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
  @user.image_name = "#{@user.name}.jpg"
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
    if File.exist?("public/user_images/#{@user.name}.jpg")
    File.delete("public/user_images/#{@user.name}.jpg")
    end
    @user.destroy
    flash[:notice] = "アカウントを削除しました"
    redirect_to("/users/index")
  end
end
