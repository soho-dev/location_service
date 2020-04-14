require 'address_cache'
namespace :cache do
  desc "Resets the AddressCache by clearing Redis data and reloading config/cache.yml settings"
  task :reset do
    AddressCache.reset
  end
end
