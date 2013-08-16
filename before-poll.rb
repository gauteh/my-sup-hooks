# Before poll hook that runs OfflineIMAP
#
# Methods are defined as a class to avoid redefining
# constants and methods.

@last_fetch = nil unless defined?(@last_fetch)

class OfflineIMAP
  def self.offlineimap(*folders)
    cmd = "offlineimap 2>&1"
    #cmd << " -f #{folders * ','}" unless folders.compact.empty?
    `#{cmd}`
  end

  def self.folder_names(sources)
    sources.map { |s| s.uri.split('/').last }
  end

  def self.inbox_sources(sources = Redwood::SourceManager.sources)
    sources.find_all { |s| !s.archived? }.sort_by {|s| s.id }
  end
end

if (@last_fetch || Time.at(0)) < Time.now - 20
  say "Running offlineimap..."
  # only check non-auto-archived sources on the first run

  log OfflineIMAP::offlineimap(@last_fetch ? nil : OfflineIMAP::folder_names(OfflineIMAP::inbox_sources))

  say "Finished offlineimap."
end

@last_fetch = Time.now

