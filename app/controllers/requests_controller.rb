class RequestsController < ApplicationController

  before_filter :authenticate_user!, except: [:show]

  helper_method :sort_column, :sort_direction
  
  def create
    @book = Book.find(params[:book_id])
    @request = Request.new(params[:request])
    @request.book = @book
    @request.user = current_user
    respond_to do |format|
      if @request.save
        format.html { redirect_to book_request_url(@book), notice: 'Request was successfully created.' }
        format.js { @request }
        format.json { render json: @request, status: :created, location: @request }
      else
        format.html { render action: "new" }
        format.js { @book }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  def index
    @book = Book.find(params[:book_id])
    @requests = @book.requests.joins(:user).order(sort_column + " " + sort_direction)
    respond_to do |format|
      format.html { render :nothing => true, :status => 200, :content_type => 'text/html' }
      format.js { @requests }
      format.json { render json: @book }
    end
  end
  
  def destroy
    @book = Book.find(params[:book_id])
    @request = Request.find(params[:id])
    @request.destroy
    @requests = @book.requests
    respond_to do |format|
      format.html { redirect_to books_url }
      format.json { head :no_content }
      format.js { }
    end
  end
  
  
  private 
  
  def sort_column
    Request.column_names.include?(params[:sort]) || (params[:sort] && User.column_names.include?(params[:sort].split('.').last)) ? params[:sort] : 'created_at'
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction]  : 'desc'
  end

end