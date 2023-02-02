class PostsController < ApplicationController

before_action :authenticate_user
before_action :ensure_correct_user, {only: [:edit, :update, :destroy]}

  def index
    user_ids = @current_user.following_user.pluck(:id) # フォローしているユーザーのid一覧
    user_ids.push(@current_user.id) # 自身のidを一覧に追加する
    @posts = Post.where(user_id: user_ids).order(created_at: :desc)
    
  end

  def show
    @post = Post.find_by(id: params[:id])
    @user = @post.user

    @likes_count = Like.where(post_id: @post.id).count
  
    #コメント機能
    @comment = Comment.new  #この行を追記
    @comments = @post.comments#.page(params[:page]).per(7).reverse_order  #この行を追記
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(content: params[:content], user_id: @current_user.id)
    
    if params[:image]
      @post.image_name = "#{@post.id}.jpg"
      image = params[:image]
      File.binwrite("public/post_images/#{@post.image_name}", image.read)
    end

    if @post.save
      flash[:notice] = "投稿を作成しました"
      redirect_to("/posts/index")
    else
      render("posts/new", status: :unprocessable_entity)
    end
  end

  def edit
    @post = Post.find_by(id: params[:id])
  end

  def update
    @post = Post.find_by(id: params[:id])
    @post.content = params[:content]

    #画像を保存
    if params[:image]
      @post.image_name = "#{@post.id}.jpg"
      image = params[:image]
      File.binwrite("public/post_images/#{@post.image_name}", image.read)
    end

    if @post.save
      flash[:notice] = "投稿を編集しました"
      redirect_to("/posts/index")
    else
      render("posts/edit", status: :unprocessable_entity)
    end
  end

  def destroy
    @post = Post.find_by(id: params[:id])
    @post.destroy
    flash[:notice] = "投稿を削除しました"
    redirect_to("/posts/index")
  end

  #投稿検索機能のアクション
  def search
    if params[:keyword]
    @posts = Post.where("content LIKE ?", "%#{params[:keyword]}%").order(created_at: :desc)
    @keyword = params[:keyword]
    end
  end

  def ensure_correct_user
    @post = Post.find_by(id: params[:id])
    if @post.user_id != @current_user.id
      flash[:notice] = "権限がありません"
      redirect_to("/posts/index")
    end
  end

end
