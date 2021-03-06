# Before poll hook that runs OfflineIMAP
#
# Methods are defined as a class to avoid redefining
# constants and methods.

@last_fetch = nil unless defined?(@last_fetch)
@poll_interval = 120 unless defined?(@poll_interval)

require 'thread'

if not defined?(OfflineIMAP)
  class OfflineIMAP
    @run_off = Mutex.new

    def self.offlineimap(*folders)
      if @run_off.try_lock
        begin
          #cmd = "sync_new_email 2>&1"
          cmd = "offlineimap 2>&1"
          #cmd << " -f #{folders * ','}" unless folders.compact.empty?
          `#{cmd}`
        ensure
          @run_off.unlock
        end
      else
        log "Previous OfflineIMAP operation still running.."
      end
    end

    def self.folder_names(sources)
      sources.map { |s| s.uri.split('/').last }
    end

    def self.inbox_sources(sources = Redwood::SourceManager.sources)
      sources.find_all { |s| !s.archived? }.sort_by {|s| s.id }
    end
  end
end

if (@last_fetch || Time.at(0)) < Time.now - @poll_interval
  say "offlineimap: running.."
  # only check non-auto-archived sources on the first run

  log OfflineIMAP::offlineimap(@last_fetch ? nil : OfflineIMAP::folder_names(OfflineIMAP::inbox_sources))

  say "offlineimap: done."
end

@last_fetch = Time.now

