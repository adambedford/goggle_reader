require 'rails_helper'

describe User, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:provider) }
    it { should validate_presence_of(:uid) }
  end

  describe ".from_omniauth", vcr: true do
    def find_or_create_user
      User.from_omniauth(auth_hash)
    end

    let(:auth_hash) { JSON.parse(File.read(Rails.root.join('spec/data_fixtures/omniauth_google.json'))) }

    context "when the user is new" do
      it "should create a new user record" do
        expect { find_or_create_user }.to change { User.count }.by(1)

      end

      it "has the right attributes" do
        user = find_or_create_user

        expect(user.name).to eq auth_hash["info"]["name"]
        expect(user.uid).to eq auth_hash["uid"]
      end
    end

    context "when the user is returning" do
      let!(:existing_user) { find_or_create_user }

      it "does not create a new user" do
        expect { find_or_create_user }.to_not change { User.count }
        expect(find_or_create_user).to eq existing_user
      end

      context "when the user's name has changed" do
        before do
          auth_hash["info"]["name"] = "Updated Name"
        end

        it "updates the name" do
          expect(find_or_create_user.name).to eq "Updated Name"
        end
      end
    end
  end
end
