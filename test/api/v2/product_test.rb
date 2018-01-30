require 'airborne'
require_relative '../api_test_config'

# Usage:
#   APITestConfig will initialize the same as watir config
#   all api test related test data are put in /test/api/data/config.yml, such as topic_id_get, application_id, secret_id etc,.

#   NOTE:
#   When testing an API call which create data in test target system. Please make sure PATCH and DELETE testing in a single test if possible
#   otherwise, there will be additional preconditions to setup for every delete test.

describe 'Products' do
  puts 'Products APIs v2'

  before(:all) {
    @config = APITestConfig.new
    @api_base_url = '/api/v2'
    @product_code_get = @config.api_data['product_code_get']
    @headers = {:Authorization => "Bearer #{@config.access_token}",
                :Accept => "application/json",
                :content_type => "application/json",
                :verify_ssl => false}
  }

  it 'can get product by id' do
    get "#{@api_base_url}/products/#{@product_code_get}?_extends=%5B%22aggregation%22%5D", @headers
    expect_status(200)
    expect_json_keys('data', [:code, :name, :description, :summary, :manufacturer,
                              :product_image, :formatted_price, :product_url, :price_value, :stock_status,
                              :updated_at, :created_at, :is_base_product, :_ref_link])
    expect_json_keys('data._aggregation', [:posts_count, :followers_count, :question_count, 
                                           :answered_questions_count, :blog_count, :review_count, :review_rating,
                                           :review_detail, :recommended_detail])
  end

  it 'can add product to cart'do
    body = {"quantity":1
    }
    post "#{@api_base_url}/products/#{@product_code_get}/add_to_cart", body, @headers
    expect_status(200)
  end


end