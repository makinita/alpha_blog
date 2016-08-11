require 'test_helper'

class CreateCategoriesTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = User.create( username:"john", email: "john@example.com", password:"passss", admin: true)
  end
  
  test "get new category form and create category" do
    #para q pase el test tenemos q simular q estamos logueados como admin
    #en el test categories_controller hicimos asi: session[:user_id] = @user.id pero aqui no se puede acceder a session
    #hacemos un metodo que lo simule
    sign_in_as(@user,"passss")
    get new_category_path
    assert_template 'categories/new' #en verdad el test de controlador hace esto tambien.
    assert_difference 'Category.count', 1 do #significa que despues del bloque debe haber una diferencia de 1 en el contador
      post_via_redirect categories_path, category: {name: "sports"}
      
    end
    assert_template 'categories/index'
    assert_match 'sports', response.body  #busca la cadena sport en la respuesta
  end
  
  #test pa ver que falla correctamente al introducir dato invalido
  test "invalid category submission results in failure" do
    sign_in_as(@user,"passss")
    get new_category_path
    assert_template 'categories/new' #en verdad el test de controlador hace esto tambien.
    assert_no_difference 'Category.count' do #significa que despues del bloque no debe haber diferencia en el contador
      #post_via_redirect categories_path, category: {name: " "} #ponemos un espacio pa q falle
      post categories_path, category: {name: " "} #para ser sintacticamente correctos, realmente hacemos un post, no hay redirect porque falla
    end
    assert_template 'categories/new'  #debe mostrar el new otra vez (tal como pone en el controlador si falla el .save)
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body' #nos aseguramos que salen los flash messages por tag y class (ver views/shared/_errors.html.erb)
  end

end