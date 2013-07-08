kptChan = new (require '../lib/kpt_chan')


module.exports = (robot) ->
  robot.respond /.+/i, (receivedMsg) ->
    kptChan.response receivedMsg, (text) ->
      receivedMsg.send text
