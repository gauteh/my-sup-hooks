# Send notification to desktop about received emails

notify_cmd="/usr/bin/notify-send -i /usr/share/icons/gnome/24x24/status/stock_mail-unread.png "

if num_inbox_total >= 1
  notify_summary="Jei! Meil! "

  notify_body = "#{num_inbox_total} "
  if num_inbox_total > 1
    notify_body << "nye meila!"
  else
    notify_body << "ny meil!"
  end

  #notify_body = ""
  #from_and_subj.each { |f,s| notify_body << "\n#{f.dump} : #{s.dump}" }
  system "#{notify_cmd} '#{notify_summary}' '#{notify_body}'"

  #system 'dbus-send --print-reply --dest=org.freedesktop.Notifications /org/freedesktop/Notifications org.freedesktop.Notifications.Notify string:"Sup" int32:1 string:"/usr/share/icons/gnome/24x24/status/mail-unread.png" string:"' << notify_summary << '" string:"" array:string:"" dict:string:boolean:"transient","true"'
end
