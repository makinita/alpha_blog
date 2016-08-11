require 'test_helper'

class CategoriesControllerTest < ActionController::TestCase
  
  def setup
    @category = Category.create(name: "sports")
    @user = User.create( username:"john", email: "john@example.com", password:"passsss", admin: true)
  end
  
  test "should get categories index" do
    get :index
    assert_response :success
  end
  
  test "should get new" do
    #esta accion solo la puede hacer un admin, simulamos aqui logueado como admin
    session[:user_id] = @user.id
    get :new
    assert_response :success
  end
  
  test "should get show" do
    get(:show, {'id' => @category.id})
    assert_response :success
  end
  
  #si no admin no debe dejar crear
  test "should redirect create when admin not logged in" do
    assert_no_difference 'Category.count' do
      post :create, category: {name: "sports" }
    end
    #al no estar logueado como admin, se debe dar esta redireccion 
    #tal como figura el before_action del controlador require_admin
    assert_redirected_to categories_path
    
  end
  
end