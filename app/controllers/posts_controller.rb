class PostsController < ApplicationController


  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: :index
  load_and_authorize_resource # before action 밑에 넣어야. 로그인 후 권한, 로그아웃하고 글쓰기 누르면 로그인 화면으로 넘어가도록

  def index
    # @posts = Post.all.page(params[:page]).per(5)
    @posts = Post.order(created_at: :desc).page(params[:page]).per(5)
    respond_to do |format|
      format.html
      format.json { render json: @posts }
    end
  end

  def new
    @post = Post.new #렌더링을 하기 위해 비어있는 @post 만들어 줌
  end

  def create
    # if params[:title].nil? or params[:content].nil?
    #   flash[:alert] = "title과 content를 채워주세요"
    #   redirect_to :back
      @post = current_user.posts.new(post_params)
      respond_to do |format|

        if @post.save
          #저장이 되었을 경우에 실행
          # flash[:notice] = "글 작성이 완료되었습니다."
          # redirect_to '/'
          format.html {redirect_to '/', notice: '글 작성 완료!!'}
        else
          #저장실패했을 경우에 (validation) 걸렸을 때 실행
          # flash[:alert] = "글 작성이 실패했습니다."
          # redirect_to new_post_path
          format.html { render :new }
          format.json { render json: @post.errors}
        end
      end

  end

  def show
    @comments = @post.comments
  end

  def edit
  end

  def update

    respond_to do |format|
    if @post.update(post_params)
      format.html {redirect_to @post, notice: '글 수정 완료!!'}
    else
      format.html { render :edit}
      format.json { render json: @post.errors }
    end
    end
  end

  def destroy
    @post.destroy
    redirect_to "/"
  end

  private
  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content, :img)
  end
end
