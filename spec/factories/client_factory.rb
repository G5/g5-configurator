FactoryGirl.define do
  factory :client, class: G5Updatable::Client do
    uid "http://example.com/clients/g5-c-1234-client"
    urn "g5-c-1234-client"
    name "Test Client"
    properties { { organization: "some-org" } }
  end
end
