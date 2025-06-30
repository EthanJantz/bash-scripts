#! /usr/bin/bash
today=$(date --date="Today")
echo "$today: Running script..." >> friendly_reminder.log

lastmod=$(curl -Ls jantz.website | grep -Eo "[A-Za-z]+ [0-9]+, [0-9]+")
lastmod=$(date --date="$lastmod" +%s)
refdate=$(date --date="last friday" +%s)
echo "$today: lastmod is $lastmod" >> friendly_reminder.log
echo "$today: refdate is $refdate" >> friendly_reminder.log

if [[ $lastmod -lt $refdate ]]; then
    echo "$today: Reminder sent" >> friendly_reminder.log
    notify-send "Friendly reminder that you haven't posted in 6 days."
fi