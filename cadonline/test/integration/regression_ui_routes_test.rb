require "test_helper"

class RegressionUiRoutesTest < ActionDispatch::IntegrationTest
  test "public pages render" do
    get about_path
    assert_response :success

    get terms_path
    assert_response :success

    get login_path
    assert_response :success

    get signup_path
    assert_response :success
  end

  test "signup requires accepted terms" do
    assert_no_difference("User.count") do
      post signup_path, params: {
        user: {
          full_name: "Teste",
          email: "novo@example.com",
          password: "SenhaSegura123",
          password_confirmation: "SenhaSegura123",
          accepted_terms: false
        }
      }
    end

    assert_response :unprocessable_entity
  end
end
