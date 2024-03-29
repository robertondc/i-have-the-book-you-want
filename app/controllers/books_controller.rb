class BooksController < ApplicationController

  before_filter :authenticate_user!, :except => [:show_user]
  
  helper_method :sort_column, :sort_direction
  
  # GET /books
  # GET /books.json
  def index
    @books = current_user.books.order(sort_column + " " + sort_direction)
    @user = current_user
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @books }
      format.js { @books }
    end
  end

  # GET /user/roberto/books
  def show_user
    @user = User.find_by_username(params[:username])
    if @user
      @books = @user.books.order(sort_column + " " + sort_direction)
    else
      flash.now[:error] = t('users.not_found')
      @books = []
    end
    respond_to do |format|
        format.html {render action: 'index' }
        format.json { render json: @books }
        format.js { render action: 'index' }
    end
  end

  # GET /books/1
  # GET /books/1.json
  def show
    @book = Book.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @book }
    end
  end

  # GET /books/new
  # GET /books/new.json
  def new
    @book = Book.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @book }
    end
  end

  # GET /books/1/edit
  def edit
    @book = Book.find(params[:id])
    unless owner?(@book)
      respond_to do |format|
        format.html { redirect_to root_url  }
      end
    end
  end

  # POST /books
  # POST /books.json
  def create
    @book = Book.new(params[:book])
    @book.user = current_user
    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: 'Book was successfully created.' }
        format.json { render json: @book, status: :created, location: @book }
      else
        format.html { render action: "new" }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /books/1
  # PUT /books/1.json
  def update
    @book = Book.find(params[:id])

    respond_to do |format|
      if @book.update_attributes(params[:book])
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book = Book.find(params[:id])
    @book.destroy

    respond_to do |format|
      format.html { redirect_to books_url }
      format.json { head :no_content }
    end
  end
  
  private 
  
  def sort_column
    Book.column_names.include?(params[:sort]) ?  params[:sort] : 'title'
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction]  : 'asc'
  end
  
end
