# frozen_string_literal: true
require 'spec_helper'
require 'valkyrie/specs/shared_specs'

RSpec.describe Valkyrie::Persistence::Redis::QueryService do
  let(:adapter) { Valkyrie::Persistence::Redis::MetadataAdapter.new(redis: redis_client) }

  before do
    redis_client.tap do |r|
      keys = r.keys('_valkyrie_*')
      r.del(*keys) unless keys.empty?
    end
  end

  it_behaves_like "a Valkyrie query provider"
end
