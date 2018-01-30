require 'airborne'
require_relative '../api_test_config'

describe 'Cart' do
  puts 'cart api test v2'
  before(:all) {
    @config = APITestConfig.new
    @api_base_url = '/api/v2'
    @product_id_get = @config.api_data['product_id_get']
    @headers = { :Authorization => "Bearer #{@config.access_token}",
                :Accept => "application/json",
                :content_type => "application/json",
                :verify_ssl => false }
    add_product_for_user
    @cart_id_get = get_cart_id
  }

  it 'Get carts by user' do
    get "#{@api_base_url}/carts", @headers
    expect_status(200)
    expect_json_keys("data.0", [:id, :member, :product])
  end

  it 'Get cart by cart id' do
    get "#{@api_base_url}/carts/#{@cart_id_get}", @headers
    expect_status(200)
    expect_json("data.id", @cart_id_get)
    expect_json_keys('data', [:id, :member, :product])
  end

  it 'Change quantity in cart (Put)' do
    body = {"quantity": 5}
    put "#{@api_base_url}/carts/#{@cart_id_get}" , body, @headers
    expect_status(200)
    expect_json("data.id", @cart_id_get)
    expect_json("data.quantity",  5)
  end

  it 'Change quantity in cart (Patch)' do
    body = {"quantity": 3}
    patch "#{@api_base_url}/carts/#{@cart_id_get}" , body, @headers
    expect_status(200)
    expect_json("data.id", @cart_id_get)
    expect_json("data.quantity",  3)
  end

  it 'Close cart by cart id' do
    post "#{@api_base_url}/carts/#{@cart_id_get}/close", {} , @headers
    expect_status(200)
    expect_json("data.id", @cart_id_get)
    expect_json("data.is_closed", true)
    get "#{@api_base_url}/carts/#{@cart_id_get}", @headers
    expect_status(404)
  end

  def add_product_for_user
    quantity = 1
    body = { "product_id": @product_id_get, "quantity": quantity }
    post "#{@api_base_url}/carts", body, @headers
  end

  def get_cart_id
    response = get "#{@api_base_url}/carts", @headers
    JSON.parse(response)["data"][0]["id"]
  end
  
end
