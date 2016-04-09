require 'rails_helper'

RSpec.describe FeedsController, type: :controller do
  describe "GET index" do
    def do_request(options = {})
      get(:index, options)
    end

    it "returns success code" do
      expect(do_request).to be_success
    end

    it "returns all feeds" do
      do_request
      expect(assigns(:feeds)).to be_a(ActiveRecord::Relation)
    end
  end

end
