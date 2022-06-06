class BooksController < ApplicationController
before_action :ensure_correct_user, only: [:edit, :update, :destroy]



  def show
    @book = Book.find(params[:id])
    @book_new = Book.new
    @user = @book.user
    @book_comment = BookComment.new
  end

  def index
     to = Time.current.at_end_of_day
     from = (to - 6.day).at_beginning_of_day
    # from = Time.current.at_beginning_of_day
    # to = (from + 6.day).at_end_of_day
    @books = Book.includes(:favorites).sort {|a,b|
        b.favorites.where(created_at: from...to).size <=>
        a.favorites.where(created_at: from...to).size
      }
    # @books = Book.includes(:favorited_users).sort {|a,b|
    #     b.favorited_users.includes(:favorites).where(created_at: from...to).size <=>
    #     a.favorited_users.includes(:favorites).where(created_at: from...to).size
    #   }
      # sort_by {|x|
      #     x.favorited_users.includes(:favorites).where(created_at: from...to).size
      #   }.reverse
      # sort {|a,b|
      #   a.favorited_users.includes(:favorites).where(created_at: from...to).size <=>
      #   b.favorited_users.includes(:favorites).where(created_at: from...to).size
      #   }.reverse

    @book = Book.new


    # @books = Book.all
    # @following_users = current_user.followings
    # @follower_users = current_user.followers

  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path, notice: "successfully delete book!"
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def ensure_correct_user
   @book = Book.find(params[:id])
    unless @book.user == current_user
    redirect_to books_path
    end
  end

end
