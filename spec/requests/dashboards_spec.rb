# frozen_string_literal: true

# SPDX-License-Identifier: GPL-3.0-or-later

require 'rails_helper'

RSpec.describe "Dashboards", type: :request do
  describe "GET /student" do
    it "returns http success" do
      get "/dashboards/student"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /instructor" do
    it "returns http success" do
      get "/dashboards/instructor"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /admin" do
    it "returns http success" do
      get "/dashboards/admin"
      expect(response).to have_http_status(:success)
    end
  end

end
