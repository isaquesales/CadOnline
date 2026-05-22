require "test_helper"

class SecurityFlowsTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(full_name: "User A", email: "usera@example.com", password: "SenhaSegura123", password_confirmation: "SenhaSegura123", accepted_terms: true, accepted_terms_at: Time.current)
    @other_user = User.create!(full_name: "User B", email: "userb@example.com", password: "SenhaSegura123", password_confirmation: "SenhaSegura123", accepted_terms: true, accepted_terms_at: Time.current)
    @document = @other_user.documents.create!(title: "Privado", paper_style: "ruled", paper_tone: "default", content: { blocks: [] })
  end

  test "redirects unauthenticated root to login" do
    get root_path
    assert_redirected_to login_path
  end

  test "prevents access to other user document" do
    post login_path, params: { email: @user.email, password: "SenhaSegura123" }
    patch document_path(@document), params: { document: { title: "Ataque" } }, as: :json
    assert_response :not_found
  end

  test "delete my data removes user and related data" do
    post login_path, params: { email: @user.email, password: "SenhaSegura123" }
    own_doc = @user.documents.create!(title: "Doc", paper_style: "ruled", paper_tone: "default", content: { blocks: [] })
    @user.favorites.create!(document: own_doc)

    assert_difference("User.count", -1) do
      assert_difference("Document.count", -1) do
        delete destroy_data_account_path
      end
    end

    assert_redirected_to signup_path
  end

  test "document title update works and does not change owner" do
    post login_path, params: { email: @user.email, password: "SenhaSegura123" }
    own_doc = @user.documents.create!(title: "Original", paper_style: "ruled", paper_tone: "default", content: { blocks: [] })

    patch document_path(own_doc), params: { document: { title: "Novo título", user_id: @other_user.id } }, as: :json
    assert_response :success

    own_doc.reload
    assert_equal "Novo título", own_doc.title
    assert_equal @user.id, own_doc.user_id
  end

  test "security headers are present" do
    get login_path
    assert_equal "SAMEORIGIN", response.headers["X-Frame-Options"]
    assert_equal "nosniff", response.headers["X-Content-Type-Options"]
    assert_equal "strict-origin-when-cross-origin", response.headers["Referrer-Policy"]
  end

  test "weak password is rejected" do
    user = User.new(full_name: "Fraco", email: "fraco@example.com", password: "abc123", password_confirmation: "abc123", accepted_terms: true, accepted_terms_at: Time.current)
    assert_not user.valid?
    assert user.errors[:password].any?
  end
end
