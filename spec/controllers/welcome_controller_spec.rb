require 'rails_helper'

RSpec.describe WelcomeController, :type => :controller, skip: true do

  describe "GET index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "uses WIP layout" do
      get :index
      expect(response).to render_template(layout: 'wip')
    end
  end

end
