require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "POST /login" do
    let!(:user) { create(:user, email: "user@example.com", password: "password") }

    context "with valid credentials" do
      it "returns http success" do
        post "/login", params: { email: "user@example.com", password: "password" }
        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid credentials" do
      it "returns unauthorized" do
        post "/login", params: { email: "user@example.com", password: "wrongpass" }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end