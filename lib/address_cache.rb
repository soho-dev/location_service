class AddressCache
  class << self
    def get(key)
      log_hit_or_miss(key)
      redis.get(key)
    rescue => e
      log_failure("get", key, e)
    end

    def set(key, value)
      redis.set(key, value, options)
    rescue => e
      log_failure("set", key, e)
    end

    def reset
      redis.flushdb
    end

    def redis
      Redis.new()
    end

    private

    def log_failure(operation, key, error)
      write_log_message(
        action:     "#{operation}_error",
        key:        key,
        log_level:  "error",
        metadata:   error.inspect
      )
    end

    def log_hit_or_miss(key)
      action = $redis.exists(key) ? "cache_hit": "cache_miss"
      write_log_message(action: action, key: key, log_level: "debug")
    end

    def write_log_message(action:, key:, log_level:, metadata: nil)
      metadata_hash = {
        source:        self.to_s,
        action:        action,
        query_string:  key,
        metadata:      metadata
      }

      Rails.logger.send(log_level, metadata_hash)

      nil
    end

    def options
      return { ex: ex } if ex
      return { px: px } if px
      {}
    end

    def ex
      eviction["ex"]
    end

    def px
      eviction["px"]
    end

    def eviction
      cache_config["eviction"]
    end

    def cache_config
      @cache_config ||= load_yaml("config/cache.yml")[ENV["RACK_ENV"]]
    end

    def load_yaml(file)
      YAML.load(ERB.new(File.read(file)).result)
    end
  end
end
