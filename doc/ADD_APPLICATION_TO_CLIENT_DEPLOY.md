# Add Application to Client Deploy

1. Add application definition config to `config/app_definitions.yml.erb` in
   g5-configurator. Example:

    ```yaml
    -
      kind: "phone-number-service"
      human_name: "Phone Number Service"
      prefix: "cpns"
      repo_url: "git@github.com:g5/g5-phone-number-service.git"
    ```

    Note: The application needs to be restarted after this addition.

2. Run the specs and fix any failing ones. There should be at least one failure
   as the number of instructions generated has changed.

3. Add application deployment config to `config/defaults.yml` in
   g5-client-app-creator. [See there for
   instructions.](http://github.com/g5search/g5-client-app-creator/docs/ADD_APPLICATION_TO_CLIENT_DEPLOY.md)
