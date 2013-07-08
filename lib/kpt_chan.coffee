MessageParser = require './message_parser'
Behavior = require './behavior'

class KPTChan
  constructor: (@robot) ->
    @parser = new MessageParser()

  response: (message, callback) ->
    @parser.parse message, (err, order) =>
      console.log order
      behavior = switch order.query
        when 'add' then new Behavior.Add order
        when 'list' then new Behavior.List order
        else new Behavior.Add order
        # TODO: urgeを実装する。
        # 相手のメッセージを待たずに、自分からTryの完了を促す振る舞い。
        # when 'urge' then new Behavior.Urge

      behavior.behave order, (err, response) ->
        console.log response
        callback response


module.exports = KPTChan
