require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.allow_http_connections_when_no_cassette = true
  c.hook_into :webmock
  c.default_cassette_options = {
    record: :new_episodes,
    re_record_interval: 1.week
  }
  c.configure_rspec_metadata!
end
