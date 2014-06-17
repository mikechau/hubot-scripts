# Description:
#   An HTTP Listener for Heroku notifications
#
# Dependencies:
#   "url": ""
#   "querystring": ""
#
# Configuration:
#   Just add <HUBOT_URL>:<PORT>/hubot/heroku/notification?room=<room>[&type=<type>]
#   to Codeship Notifications under webhook url
#
# URLS:
#   Post /hubot/heroku/notification?room=room&[type=type]
#
# Authors:
#   mikechau
#
# Notes:
#   Based on the github-pull-request-notifier.coffee script by spajus

url = require('url')
querystring = require('querystring')

module.exports = (robot) ->
  robot.router.post "/hubot/heroku/notification", (req, res) ->
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
      console.log "Heroku Notification Error: #{e} Request: #{req.body}"

    res.end ""

annouceStatus = (data, cb) ->

  cb "[#{data.app}] (#{data.head}): deployed successfully - #{data.url} "
