require "test_helper"

class IpToolsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get ip_tools_new_url
    assert_response :success
  end

  test "should get create" do
    get ip_tools_create_url
    assert_response :success
  end
end
