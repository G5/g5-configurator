require 'spec_helper'

describe AppDefinition do
  describe "ALL" do
    subject { AppDefinition::ALL.map(&:kind) }

    it { should_not be_empty }
    it { should include("content-manangement-system") }
    it { should include(CLIENT_APP_CREATOR_KIND) }
  end

  describe "CLIENT_APP_DEFINITIONS" do
    subject { AppDefinition::CLIENT_APP_DEFINITIONS.map(&:kind) }

    it { should_not be_empty }
    it { should include("content-manangement-system") }
    it { should_not include(CLIENT_APP_CREATOR_KIND) }
  end

  describe ".all_kinds" do
    subject { AppDefinition.all_kinds }

    it { should_not be_empty }
    it { should include("content-manangement-system") }
  end

  describe ".for_kind" do
    subject { AppDefinition.for_kind(kind) }

    context "passed a known kind" do
      let(:kind) { "content-manangement-system" }
      its(:kind) { should eq("content-manangement-system") }
    end

    context "passed an unknown kind" do
      let(:kind) { "lolcat-generator" }
      it { should be_nil }
    end
  end

  describe "basic attributes" do
    subject do
      AppDefinition.new(
        kind: "test kind",
        human_name: "Test Name",
        prefix: "test-",
        repo_url: "http://example.org"
      )
    end

    its(:kind) { should eq("test kind") }
    its(:human_name) { should eq("Test Name") }
    its(:prefix) { should eq("test-") }
    its(:repo_url) { should eq("http://example.org") }
  end

  describe "#non_client?" do
    subject { AppDefinition.new(attributes).non_client? }

    context "instantiated with no non_client attribute" do
      let(:attributes) { {} }
      it { should be_false }
    end

    context "instantiated with a true non_client attribute" do
      let(:attributes) { { non_client: true } }
      it { should be_true }
    end
  end
end
