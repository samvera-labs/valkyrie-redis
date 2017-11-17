# frozen_string_literal: true
SOLR_TEST_URL = "http://127.0.0.1:#{ENV['TEST_JETTY_PORT'] || 8984}/solr/blacklight-core-test"
RSpec.configure do |config|
  config.before do
    # Suppress all the warnings about Solr generating IDs
    Valkyrie.logger.level = Logger::ERROR
    client = RSolr.connect(url: SOLR_TEST_URL)
    client.delete_by_query("*:*")
    client.commit
  end
end

def solr_commit_params(value)
  params = value.nil? ? { softCommit: true } : { commitWithin: 10 }
  Kernel.silence_warnings do
    Valkyrie::Persistence::Solr::Repository.const_set(:COMMIT_PARAMS, params)
  end
end
