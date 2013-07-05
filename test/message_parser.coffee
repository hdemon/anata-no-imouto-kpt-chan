chai      = require('chai')
expect    = chai.expect
should    = chai.should()
sinon     = require('sinon')
sinonChai = require('sinon-chai')

chai.use(sinonChai)

MessageParser = require('../lib/message_parser')


describe "MessageParser", ->
  beforeEach (done) ->
    @mp = new MessageParser()
    done()

  describe "parse", ->
    beforeEach (done) ->
      @result = {}

      msg = '"abcde"をkeepして。'
      @mp.parse msg, (err, @result) =>
        done()

    it "should have category, query, subject property", ->
      expect(@result).to.have.property('category')
      expect(@result).to.have.property('query')
      expect(@result).to.have.property('subject')

    it "should give string by parsing the message", ->
      expect(@result.category).to.equal('keep')
      # 意図としてはaddだが、今回は明示していないので、空文字列であることは正しい。
      expect(@result.query).to.equal('')
      expect(@result.subject).to.equal('abcde')


describe "", ->

  describe "", ->

  describe "execute", ->
