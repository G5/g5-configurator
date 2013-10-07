CLIENT_APP_CREATOR_KIND = "client-app-creator"
CLIENT_APP_CREATOR_DEPLOYER_KIND = "client-app-creator-deployer"

app_definitions_path = Rails.root.join("config", "app_definitions.yml.erb")
parsed_app_definitions = ERB.new(File.read(app_definitions_path)).result

YAML.load(parsed_app_definitions).each do |attributes|
  AppDefinition.create_and_register(attributes.with_indifferent_access)
end
