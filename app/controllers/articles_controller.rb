class ArticlesController < ApplicationController
  
  before_action :set_article, only: [:edit, :update, :show, :destroy]
  before_action :require_user, except: [:index, :show]
  before_action :require_same_user, only: [:edit, :update, :destroy]
  
  def index
    #@articles = Article.all
    @articles = Article.paginate(page: params[:page], per_page: 5)
  end
  
  def new
    #debugger
    @article = Article.new
  end
  
  def edit
  end
  
  def create
    #debugger
    #render plain: params[:article].inspect
    
    @article = Article.new(article_params)
    #@article.user = User.first #hack pa mientras..
    @article.user = current_user
    
    if @article.save
      flash[:success] = "Articulo creado con éxito"
      redirect_to article_path(@article)
    else
      render 'new'
    end
  end
  
  def update
    if @article.update(article_params)
      flash[:success] = "Articulo editado con éxito"
      redirect_to article_path(@article)
    else
      render 'edit'
    end
    
  end
  
  def show
  end
  
  def destroy
    @article.destroy
    flash[:danger] = "Articulo eliminado con éxito"
    redirect_to articles_path
  end
  
  private
  def set_article
    @article = Article.find(params[:id])
  end
  def article_params
    #params.require(:article).permit(:title, :description)
    #tras añadir los checkboxes de asignar categoria, añadimos al whitelist lo siguiente
    #indicando de esta manera que category_ids es un array (se puede comprobar al enviar form erroneamente,
    #viendo abajo en el debuger de los params que los category_ids son un array con los seleccionados)
    params.require(:article).permit(:title, :description, category_ids: [])
  end
  def require_same_user
    if current_user != @article.user and !current_user.admin?
      flash[:danger] = "You can only edit or destroy your own articles"
      redirect_to root_path
    end
  end
end