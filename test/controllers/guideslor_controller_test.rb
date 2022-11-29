require "test_helper"

class GuideslorControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get guideslor_index_url
    assert_response :success
  end
end
