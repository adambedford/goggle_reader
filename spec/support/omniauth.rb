module OmniauthHelpers
  def omniauth_google_hash
    OmniAuth::AuthHash.new(JSON.parse(File.read(Rails.root.join('spec/data_fixtures/omniauth_google.json'))))
  end
end