# frozen_string_literal: true

# SPDX-License-Identifier: GPL-3.0-or-later

require 'rails_helper'

RSpec.describe "Quizzes", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/quizzes/show"
      expect(response).to have_http_status(:success)
    end
  end

end
