CLIENT_APP_CREATOR_KIND = "g5-client-app-creator"
CLIENT_APP_CREATOR_DEPLOYER_KIND = "g5-client-app-creator-deployer"

AppDefinition.create_and_register(
  kind: CLIENT_APP_CREATOR_KIND,
  human_name: "Client App Creator",
  prefix: nil,
  repo_url: "git@github.com:g5search/g5-client-app-creator.git",
  non_client: true
)

AppDefinition.create_and_register(
  kind: CLIENT_APP_CREATOR_DEPLOYER_KIND,
  human_name: "Client App Creator Deployer",
  prefix: nil,
  repo_url: "git@github.com:g5search/g5-sibling-deployer.git",
  non_client: true
)

AppDefinition.create_and_register(
  kind: "g5-client-hub",
  human_name: "Client Hub",
  prefix: "ch",
  repo_url: "git@github.com:g5search/g5-client-hub.git"
)

AppDefinition.create_and_register(
  kind: "g5-client-hub-deployer",
  human_name: "Client Hub Deployer",
  prefix: "chd",
  repo_url: "git@github.com:g5search/g5-sibling-deployer.git"
)

AppDefinition.create_and_register(
  kind: "g5-client-lead-service",
  human_name: "Client Leads Service",
  prefix: "cls",
  repo_url: "git@github.com:g5search/g5-client-leads-service.git"
)
