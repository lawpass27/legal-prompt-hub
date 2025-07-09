require "test_helper"

class LegalPromptsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get legal_prompts_index_url
    assert_response :success
  end

  test "should get show" do
    get legal_prompts_show_url
    assert_response :success
  end

  test "should get new" do
    get legal_prompts_new_url
    assert_response :success
  end

  test "should get create" do
    get legal_prompts_create_url
    assert_response :success
  end

  test "should get edit" do
    get legal_prompts_edit_url
    assert_response :success
  end

  test "should get update" do
    get legal_prompts_update_url
    assert_response :success
  end

  test "should get destroy" do
    get legal_prompts_destroy_url
    assert_response :success
  end
end
