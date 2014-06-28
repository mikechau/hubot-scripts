# Description:
#   An HTTP Listener for Papertrail notifications
#
# Dependencies:
#   "url": ""
#   "querystring": ""
#
# Configuration:
#   Just add <HUBOT_URL>:<PORT>/hubot/papertrail/notification?room=<room>[&type=<type>]
#   to Papertrail Alerts under webhook url
#
# URLS:
#   Post /hubot/papertrail/notification?room=room&[type=type]
#
# Authors:
#   mikechau
#
# Notes:
#   Based on the github-pull-request-notifier.coffee script by spajus

url = require('url')
querystring = require('querystring')

module.exports = (robot) ->
  robot.router.post "/hubot/papertrail/notification", (req, res) ->
    query = querystring.parse(url.parse(req.url).query)

    data = req.body
    type = query.type
    room = query.room

    if type is 'irc'
      room = '#' + room

    try
      annouceStatus data, (what) ->
        robot.messageRoom room, what
    catch e
      robot.messageRoom room, "(╯°□°)╯︵ ┻━┻ OH NOES! #{e}"
      console.log "Papertrail Notification Error: #{e} Request: #{JSON.parse(req.body)}"

    res.end ""

annouceStatus = (data, cb) ->
  payload = JSON.parse(data.payload)
  events = payload.events
  count = events.length
  last_event = events[count - 1]


  cb "[Papertrail]: (#{last_event.source_name}) has #{count} occurrences for #{last_event.message}"