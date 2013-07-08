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


class Behavior.List extends Behavior.Base
  _behave: (order, callback) =>
    Article[order.category]
      .find
        category: order.category
        isUnresolved: true
      , (err, docs) =>
        for doc in docs
          @setResponse(@_deserialize doc)
          callback err, @response

  _deserialize: (doc) ->
    dateTime = moment(doc.date).local().format("YY-MM-DD HH:mm")
    "#{doc.category}(#{doc.incrementalId})  #{doc.body} (#{dateTime} #{doc.speaker})"


class Behavior.Remove extends Behavior.Base
  _behave: (order, callback) =>
    @_remove order, callback

  _remove: (order, callback) ->
    Article[order.category]
      .update
        incrementalId: order.incrementalId
        isUnresolved: true
      ,
        isUnresolved: false
      , (err, docs) =>
        @setResponse "#{order.incrementalId}を消しました。"
        callback err, @response

  # TODO: 実装しろ
  _removeAll: (order, callback) ->


module.exports = Behavior
