# frozen_string_literal: true
# - parses json responses
# - fails with descriptive output when a request fails
class ConsulSyncer
  class Wrapper
    BACKOFF = [0.1, 0.5, 1.0, 2.0].freeze

    class ConsulError < StandardError
    end

    def initialize(consul)
      @consul = consul
    end

    def request(method, path, payload = nil)
      retry_on_error do
        args = [path]
        args << payload.to_json if payload
        response = @consul.send(method, *args)
        if response.status == 200
          if method == :get
            JSON.parse(response.body)
          else
            true
          end
        else
          raise(
            ConsulError,
            "Failed to request #{response.env.method} #{response.env.url}: #{response.status} -- #{response.body}"
          )
        end
      end
    end

    private

    def retry_on_error
      yield
    rescue Faraday::Error, ConsulError
      retried ||= 0
      backoff = BACKOFF[retried]
      raise unless backoff
      retried += 1

      warn "Consul request failed, retrying in #{backoff}s"
      sleep backoff
      retry
    end
  end
end
