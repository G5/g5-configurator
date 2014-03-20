class AppDefinition
  ALL = []
  CLIENT_APP_DEFINITIONS = []

  attr_reader :kind, :human_name, :prefix, :repo_url

  def self.all_kinds
    @all_kinds ||= ALL.map(&:kind)
  end

  def self.for_kind(kind)
    AppDefinition::ALL.detect { |a| a.kind == kind }
  end

  def self.create_and_register(attributes)
    new(attributes).tap do |app_definition|
      AppDefinition::ALL << app_definition

      unless app_definition.non_client?
        AppDefinition::CLIENT_APP_DEFINITIONS << app_definition
      end
    end
  end

  def initialize(attributes)
    @kind = attributes[:kind]
    @human_name = attributes[:human_name]
    @prefix = attributes[:prefix]
    @repo_url = attributes[:repo_url]
    @non_client = attributes[:non_client] || false
  end

  def non_client?
    @non_client
  end
end
