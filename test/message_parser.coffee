chai      = require('chai')
expect    = chai.expect
should    = chai.should()
sinon     = require('sinon')
sinonChai = require('sinon-chai')

chai.use(sinonChai)

MessageParser = require('../lib/message_parser')

message = '"abcde"をkeepして。'
mecabResult = [ [ 'abcde', '名詞', '一般', '*', '*', '*', '*', '*' ],
  [ 'を', '助詞', '格助詞', '一般', '*', '*', '*', 'を', 'ヲ', 'ヲ' ],
  [ 'keep', '名詞', '一般', '*', '*', '*', '*', '*' ],
  [ '。', '記号', '句点', '*', '*', '*', '*', '。', '。', '。' ] ]


describe "MessageParser", ->
  beforeEach (done) ->
    @mp = new MessageParser()
    done()

  describe "parse", ->
    beforeEach (done) ->
      sinon.stub @mp, "_parse", (dummy, callback) -> callback null, mecabResult
      @result = {}

      @mp.parse message, (err, @result) =>
        done()

    it "should have category, query, subject property", ->
      expect(@result).to.have.property('category')
      expect(@result).to.have.property('query')
      expect(@result).to.have.property('subject')

    it "should give string by parsing the message", ->
      expect(@result.category).to.equal('keep')
      # クエリを明示しない場合、addとして解釈させるため、この時点で空文字列であることは想定された動作。
      expect(@result.query).to.equal('')
      expect(@result.subject).to.equal('abcde')


describe "", ->

  describe "", ->

  describe "execute", ->
