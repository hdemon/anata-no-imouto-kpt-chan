chai      = require('chai')
expect    = chai.expect
should    = chai.should()
sinon     = require('sinon')
sinonChai = require('sinon-chai')
chai.use(sinonChai)
KPTChan = require('../lib/kpt_chan')


describe "KPTChan", ->
  beforeEach (done) ->
    @mp = new KPTChan()
    done()

  describe "response", ->
    beforeEach (done) ->
      @mock = sinon.mock @mp.parser
      @mock.expects("parse").returns({category:'fuga', query:'hoge', subject:'foo'}).once()
      @result = @mp.response(null)
      done()

    it "should call MessageParser.prototype.parse", ->
      expect(@result).to.deep.equal {category:'fuga', query:'hoge', subject:'foo'}
      @mock.verify()

    afterEach ->
     @mock.restore()
