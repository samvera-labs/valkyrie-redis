# frozen_string_literal: true
require 'spec_helper'
require 'valkyrie/specs/shared_specs'

RSpec.describe Valkyrie::Persistence::Redis::MetadataAdapter do
  before do
    Redis.new.tap do |r|
      keys = r.keys('_valkyrie_*')
      r.del(*keys) unless keys.empty?
    end
  end

  let(:adapter) { described_class.new(expiration: nil) }
  it_behaves_like "a Valkyrie::MetadataAdapter"

  describe 'with expiring keys' do
    before do
      class Resource < Valkyrie::Resource
        attribute :id, Valkyrie::Types::ID.optional
      end
    end
    after do
      Object.send(:remove_const, :Resource)
    end

    let(:id) { SecureRandom.uuid }
    let(:adapter) { described_class.new(expiration: 2) }
    let(:persister) { adapter.persister }
    let(:query_service) { adapter.query_service }
    let!(:expiring_resource) { adapter.persister.save(resource: Resource.new(id: id)) }

    it 'is still available before expiring' do
      sleep(1)
      expect(query_service.find_by(id: expiring_resource.id)).to be_a(Valkyrie::Resource)
    end

    it 'is not available after expiring' do
      sleep(3)
      expect { query_service.find_by(id: expiring_resource.id) }.to raise_error(Valkyrie::Persistence::ObjectNotFoundError)
    end

    it 'knows when a resource is gone' do
      persister.delete(resource: expiring_resource)
      expect(query_service.gone?(id: expiring_resource.id)).to be true
    end
  end
end
