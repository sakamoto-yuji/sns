class PostsController < ApplicationController
  before_action :authenticate_user!
#  before_action :ensure_correct_user, {only: [:edit, :update, :destroy]}

  #メソッド定義
  def ensure_correct_user
    @post = Post.find_by(id: params[:id])
    if @post.user_id != @current_user.id
      flash[:notice] = "権限がありません"
      redirect_to(posts_path)
    end
  end

#アクション 
  def index
    @posts = Post.all.order(updated_at: :desc)
  end

  def show
   @post = Post.find_by(id:params[:id])
   @user = @post.user
  end

  def new
  @post = Post.new
  end 

  def create
   @post = Post.new(
     content:params[:content],
     user_id:current_user.id
   )
   if @post.save
    flash[:notice] = "投稿しました"
     redirect_to(posts_path)
    else
     render(new_post_path)
   end
  end

  def edit
   @post = Post.find_by(id:params[:id])
  end

  def update
  @post = Post.find_by(id: params[:id])
  @post.content = params[:content]

  # contentが空でないか確認
  if @post.content.blank?
    flash[:alert] = "コンテンツを入力してください"
    render :edit
    return
  end

  if @post.save
    flash[:notice] = "投稿を編集しました"
    redirect_to posts_path
  else
    render :edit
  end
end


  def destroy
   @post = Post.find_by(id: params[:id])
   @post.destroy
   flash[:notice] = "投稿を削除しました"
   redirect_to(posts_path)
  end
end
