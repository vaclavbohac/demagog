# frozen_string_literal: true

module Store
  class HashStore
    def initialize
      @storage = {}
    end

    def get(key)
      @storage[key]
    end

    def set(key, value)
      @storage[key] = value
    end

    def del(key)
      @storage.delete(key)
    end

    def empty?
      @storage.empty?
    end
  end
end
