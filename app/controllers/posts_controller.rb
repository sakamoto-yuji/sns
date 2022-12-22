class PostsController < ApplicationController
  def index
    @posts = Post.all.order(updated_at: :desc)
  end

  def show
   @post = Post.find_by(id:params[:id])
  end

  def new
  @post = Post.new
  end 

  def create
   @post = Post.new(content:params[:content])
   if @post.save
    flash[:notice] = "ツイートしました"
     redirect_to("/posts/index")
    else
     render("posts/new")
   end
  end

  def edit
   @post = Post.find_by(id:params[:id])
  end

  def update
   @post = Post.find_by(id:params[:id])
   @post.content = params[:content]
   if @post.save
    flash[:notice] = "ツイートを編集しました"
     redirect_to("/posts/index")
   else
     render("posts/edit")
   end
  end
  
  def destroy
   @post = Post.find_by(id: params[:id])
   @post.destroy
   flash[:notice] = "ツイートを削除しました"
   redirect_to("/posts/index")
  end
end
