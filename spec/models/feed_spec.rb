require 'rails_helper'

RSpec.describe Feed, type: :model do
  subject { feeds(:bbc_world_feed) }

  describe "validations" do
    it { should validate_presence_of(:url)}
  end
end
