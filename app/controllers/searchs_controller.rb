class SearchsController < ApplicationController
  def search
    # viewのform_tagにて
    # 選択したmodelの値を@modelに代入。
    @model = params["model"]
    # 選択した検索方法の値を@methodに代入。
    @content = params["content"]
    # 検索ワードを@contentに代入。
    @method = params["method"]
    # @model, @content, @methodを代入した、
    # search_forを@recordsに代入。
    @records = search_for(@model, @content, @method)
  end

  private
  def search_for(model, content, method)
    # 選択したモデルがuserだったら
    if model == 'user'
      # 選択した検索方法がが完全一致だったら
      if method == 'perfect'
        User.where(name: content)
        # 選択した検索方法がが部分一致だったら
      elsif method == 'partial'
        User.where('name LIKE ?', "%#{content}%")
        # 選択した検索方法がが前方一致だったら
      elsif method == 'forward'
        User.where('name LIKE ?', "#{content}%")
        # 選択した検索方法がが後方一致だったら
      elsif method == 'backword'
        User.where('name LIKE ?', "%#{content}")
      else
        User.all
      end
    # 選択したモデルがbookだったら
    elsif model == 'book'
      if method == 'perfect'
        Book.where(title: content)
      elsif method == 'partial'
        Book.where('title LIKE ?', "%#{content}%")
      elsif method == 'forward'
        Book.where('title LIKE ?', "#{content}%")
      elsif method == 'backword'
        Book.where('title LIKE ?', "%#{content}")
      else
        Book.all
      end
    end
  end
end
