# frozen_string_literal: true
require 'spec_helper'
require 'valkyrie/specs/shared_specs'

RSpec.describe Valkyrie::Persistence::Redis::Persister do
  let(:adapter) { Valkyrie::Persistence::Redis::MetadataAdapter.new(redis: redis_client) }
  let(:query_service) { adapter.query_service }
  let(:persister) { adapter.persister }

  before do
    redis_client.tap do |r|
      keys = r.keys('_valkyrie_*')
      r.del(*keys) unless keys.empty?
    end
  end

  it_behaves_like "a Valkyrie::Persister"
end
