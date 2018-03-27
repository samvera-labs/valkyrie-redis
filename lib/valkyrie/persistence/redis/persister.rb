# frozen_string_literal: true
module Valkyrie::Persistence::Redis
  class Persister
    attr_reader :adapter
    delegate :cache, to: :adapter
    delegate :cache_prefix, :expiration, to: :adapter

    # @param adapter [Valkyrie::Persistence::Memory::MetadataAdapter] The memory adapter which
    #   holds the cache for this persister.
    def initialize(adapter:)
      @adapter = adapter
    end

    # @param resource [Valkyrie::Resource] The resource to save.
    # @return [Valkyrie::Resource] The resource with an `#id` value generated by the
    #   persistence backend.
    def save(resource:)
      resource = generate_id(resource) if resource.id.blank?
      resource.created_at ||= Time.current
      resource.updated_at = Time.current
      resource.new_record = false
      normalize_dates!(resource)
      ensure_multiple_values!(resource)
      resource.tap { |r| cache.set(key_for(r), Marshal.dump(r), ex: expiration) }
    end

    # @param resources [Array<Valkyrie::Resource>] List of resources to save.
    # @return [Array<Valkyrie::Resource>] List of resources with an `#id` value
    #   generated by the persistence backend.
    def save_all(resources:)
      resources.map do |resource|
        save(resource: resource)
      end
    end

    # @param resource [Valkyrie::Resource] The resource to delete from the persistence
    #   backend.
    def delete(resource:)
      mark_deleted(key_for(resource))
    end

    def wipe!
      keys = cache.keys("#{cache_prefix}*")
      keys.each { |key| mark_deleted(key) }
    end

    private

      def mark_deleted(key)
        if expiration.nil?
          cache.del(key)
        else
          cache.set(key, "__GONE__", ex: expiration)
        end
      end

      def key_for(resource)
        "#{cache_prefix}#{resource.id}"
      end

      def generate_id(resource)
        resource.new(id: SecureRandom.uuid, created_at: Time.current)
      end

      def ensure_multiple_values!(resource)
        bad_keys = resource.attributes.except(:internal_resource, :created_at, :updated_at, :new_record, :id).select do |_k, v|
          !v.nil? && !v.is_a?(Array)
        end
        raise ::Valkyrie::Persistence::UnsupportedDatatype, "#{resource}: #{bad_keys.keys} have non-array values, which can not be persisted by Valkyrie. Cast to arrays." unless bad_keys.keys.empty?
      end

      def normalize_dates!(resource)
        resource.attributes.each { |k, v| resource.send("#{k}=", normalize_date_values(v)) }
      end

      def normalize_date_values(v)
        return v.map { |val| normalize_date_value(val) } if v.is_a?(Array)
        normalize_date_value(v)
      end

      def normalize_date_value(value)
        return value.utc if value.is_a?(DateTime)
        return value.to_datetime.utc if value.is_a?(Time)
        value
      end
  end
end
