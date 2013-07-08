_ = require 'lodash'
moment = require 'moment'

mongoose = require 'mongoose'
# TODO: 設定ファイルを設けてそこに記述
mongoose.connect 'mongodb://localhost/kpt'

Schema = mongoose.Schema

ArticleSchema = new Schema
  incrementalId: Number
  speaker: String
  category: String
  body: String
  schedule: Date
  room: String
  isUnresolved: Boolean

Article = {}
Article.keep = mongoose.model('Keep', ArticleSchema)
Article.problem = mongoose.model('Problem', ArticleSchema)
Article.try = mongoose.model('Try', ArticleSchema)


Behavior = {}
class Behavior.Base
  constructor: (order) ->
    @article = new Article[order.category]

  behave: (order, callback) ->
    @_behaveNow order, callback

  _behaveNow: (order, callback) ->
    @_behave order, callback

  getResponse: -> @response

  setResponse: (@response) ->


class Behavior.Add extends Behavior.Base
  _behave: (order, callback) ->
    # TODO: promiseで書きなおす。
    @_getMaxIncrementalId order, (err, id) =>
      _.extend @article,
        incrementalId: id + 1
        speaker: order.from
        category: order.category
        body: order.subject
        room: order.room
        isUnresolved: true
        schedule: new Date()

      @article.save (err) =>
        console.log err if err
        callback err, @response

  _getMaxIncrementalId: (order, callback) ->
    Article[order.category]
      .find()
      .sort('-incrementalId')
      .limit(1)
      .exec (err, coll) ->
        id = switch _.isUndefined coll[0]
          when true then 0
          when false then coll[0].incrementalId
        callback err, id


class Behavior.Urge extends Behavior.Base


module.exports = Behavior
