class BookCommentsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @book = Book.find(params[:book_id])
    @comment = current_user.book_comments.new(book_comment_params)
    @comment.book_id = @book.id
    @comment.save
    render :book_comments #render先にjsファイルを指定
    # redirect_to request.referer　＃非同期通信のため削除
  end
  
  def destroy
    BookComment.find(params[:id]).destroy
    #renderしたときに@bookのデータがないので@bookを定義
    @book = Book.find(params[:book_id])
    render :book_comments #render先にjsファイルを指定
    # redirect_to request.referer
  end

  private

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end

end
