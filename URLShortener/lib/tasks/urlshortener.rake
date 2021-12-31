namespace :urlshortener do
  desc "Purge stale URLs (visited > mins)"
  task :prune_urls, [:mins] => :environment do |t, args|
    mins = args[:mins] || (60 * 24)
    mins = mins.to_i
    puts "Purging stale URLs not visited in #{mins} mins"
    puts "Pruned [#{ShortenedUrl.prune(mins).count}] shortened url records."
  end
end