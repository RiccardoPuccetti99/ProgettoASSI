require "test_helper"

class GuidestftControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get guidestft_index_url
    assert_response :success
  end
end
