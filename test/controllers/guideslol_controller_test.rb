require "test_helper"

class GuideslolControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get guideslol_index_url
    assert_response :success
  end
end
