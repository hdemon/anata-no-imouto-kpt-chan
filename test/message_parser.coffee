chai      = require('chai')
expect    = chai.expect
should    = chai.should()
sinon     = require('sinon')
sinonChai = require('sinon-chai')

chai.use(sinonChai)

MessageParser = require('../lib/message_parser')

msg = {}
msg.message = {text: '"abcde"をkeepして。'}

mecabResult = [ [ 'abcde', '名詞', '一般', '*', '*', '*', '*', '*' ],
  [ 'を', '助詞', '格助詞', '一般', '*', '*', '*', 'を', 'ヲ', 'ヲ' ],
  [ 'keep', '名詞', '一般', '*', '*', '*', '*', '*' ],
  [ '。', '記号', '句点', '*', '*', '*', '*', '。', '。', '。' ] ]


describe "MessageParser", ->
  beforeEach (done) ->
    @mp = new MessageParser()
    done()

  describe "parse", ->
    it "should give string by parsing the message", ->
