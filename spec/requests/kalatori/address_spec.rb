require 'rails_helper'

RSpec.describe "Kalatori::Addresses", type: :request do
  describe "GET /generate" do
    it "returns http success" do
      get "/kalatori/address/generate"
      expect(response).to have_http_status(:success)
    end
  end

end
