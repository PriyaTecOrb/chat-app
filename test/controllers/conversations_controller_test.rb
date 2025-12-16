require "test_helper"

class ConversationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)  # Assuming you have a users fixture
    sign_in @user
  end

  test "should create conversation" do
    assert_difference('Conversation.count') do
      post conversations_path, params: { 
        conversation: { 
          title: 'Test Conversation',
          user_ids: [users(:two).id]  # Assuming you have at least two users in fixtures
        } 
      }
    end
    assert_redirected_to conversation_path(Conversation.last)
  end

  test "should not create conversation when not signed in" do
    sign_out @user
    assert_no_difference('Conversation.count') do
      post conversations_path, params: { conversation: { title: 'Test' } }
    end
    assert_redirected_to new_user_session_path
  end
end
