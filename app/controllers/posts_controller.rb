class PostsController < ApplicationController
  # GET /posts
  # GET /posts.xml
theme APP_THEME
  def index
    @posts = Post.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @posts.to_xml }
    end
  end

  # GET /posts/1
  # GET /posts/1.xml
  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @post.to_xml }
    end
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1;edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.xml
  def create
    @user = current_user
    @post = Post.new(params[:post])
    @post.blog = @blog
    @blog = @user.blog ||= Blog.new

    respond_to do |format|
      if @post.duplicate? or @blog.posts << @post
        flash[:notice] = 'Post was successfully created.'
        format.html { redirect_to post_url(:id => @post) }
        format.xml  { head :created, :location => post_url(@post) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @post.errors.to_xml }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.xml
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        flash[:notice] = 'Post was successfully updated.'
        format.html { redirect_to post_url(@post) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post.errors.to_xml }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.xml  { head :ok }
    end
  end
end
