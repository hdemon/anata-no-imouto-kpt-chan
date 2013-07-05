KPTChan = require '../lib/kpt_chan'
bot = new KPTChan()

module.exports = (robot) ->
  robot.respond /.+/i, (msg) ->
    bot.behave(msg)
