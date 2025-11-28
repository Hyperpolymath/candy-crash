# frozen_string_literal: true

# SPDX-License-Identifier: GPL-3.0-or-later

require 'rails_helper'

RSpec.describe "QuizAttempts", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/quiz_attempts/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/quiz_attempts/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/quiz_attempts/show"
      expect(response).to have_http_status(:success)
    end
  end

end
