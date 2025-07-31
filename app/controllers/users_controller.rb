class UsersController < ApplicationController
  before_action :authenticate_user!,{only:[:index,
                                           :show,
                                           :edit,
                                           :update,
                                           :following,
                                           :followers
                                          ]}
  #  before_action :forbid_login_user,{only:[:new,:create,:login_form,:login]}
  #  before_action :ensure_correct_user,{only:[:edit,:update,:destroy]}

  def following
    @title = "フォロー中"
    @user  = User.find(params[:id])
    @users = @user.following
    render 'show_follow'
  end

  def followers
    @title = "フォロワー"
    @user  = User.find(params[:id])
    @users = @user.followers
    render 'show_follow'
  end

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
    @posts = @user.posts.order(created_at: :desc)
    @likes = current_user.likes.includes(:post)
  end

  def new
    @user = User.new
  end


def create
  @user = User.new(user_params)

  if @user.save(context: :registration)
    session[:user_id] = @user.id

    if @user.image = "#{@user.id}.jpg"
      image = params[:image]

      begin
        File.binwrite("public/user_images/#{@user.image}", image.read)
        @user.update(image: @user.image_name) # ここで更新
      rescue => e
        Rails.logger.error("Image upload failed: #{e.message}")
        @user.image = "default_image.jpg" # エラー時はデフォルト画像に設定
      end
    else
      @user.update(image: "default_image.jpg")
    end

    if @user.save

      # 成功時の処理（例: リダイレクト）
      redirect_to root_path, notice: 'ユーザーが作成されました。'
    else
      # 保存に失敗した場合の処理
      render :new, alert: 'ユーザーの作成に失敗しました。'
    end
  end
end






  def edit
    begin
      @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "ユーザーが見つかりませんでした。"
      redirect_to users_path(current_user)  
    end
  end
  
  def update
    Rails.logger.info "Update action called"
    @user = current_user  # current_userを使用してユーザーを取得

    # パラメータから名前とメールを更新
    @user.name = update_params[:name]
    @user.email = update_params[:email]

    # 画像が提供されている場合、画像を保存
    if image = update_params[:image]
      File.binwrite("public/user_images/#{@user.id}.jpg", image.read)
      @user.image = "#{@user.id}.jpg"
    end

    # ユーザー情報を保存
    if @user.save
      flash[:notice] = "アカウント情報を編集しました"
      redirect_to(user_path(id: @user.id))
    else
      flash[:alert] = "アカウント情報の更新に失敗しました。"
      render("users/edit")
    end
  end

 

  def destroy
    @user = User.find_by(id: params[:id])
    if @user.image == "default_image.jpg"

    else
      if File.exist?("public/user_images/#{@user.image}")
        File.delete("public/user_images/#{@user.image}")
      end

    end
    @user.destroy
    flash[:notice] = "アカウントを削除しました"
    redirect_to(root_path)
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

  private

    def user_params
      params.permit(:name, :email, :password, :image)
    end

    def update_params
      params.require(:user).permit(:name, :email, :image)
    end


end
