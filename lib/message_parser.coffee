_ = require 'lodash'
_s = require 'underscore.string'
RSVP = require 'rsvp'
moment = require 'moment'

MeCab = new require('mecab-async')
mecab = new MeCab()

categoryWordMap = require './category_word_map'
queryWordMap = require './query_word_map'


class MessageParser
  parse: (msg, callback) ->
    text = msg.message.text
    category = ''
    query = ''
    subject = ''
    incrementalId = null
    dateTime = null
    promises = []

    promises.push new RSVP.Promise (resolve, reject) =>
      @_parse text , (err, parsedText) =>
        category = @_getCategory parsedText
        resolve()

    promises.push new RSVP.Promise (resolve, reject) =>
      @_parse text, (err, parsedText) =>
        query = @_getQuery parsedText
        resolve()

    promises.push new RSVP.Promise (resolve, reject) =>
      subject = @_getSubject text
      resolve()

    promises.push new RSVP.Promise (resolve, reject) =>
      incrementalId = @_getIncrementalId text
      resolve()

    promises.push new RSVP.Promise (resolve, reject) =>
      dateTime = @_getDateTime text
      resolve()

    RSVP.all(promises).then ->
      from = msg.message.user.name
      room = msg.message.user.room

      callback null, {incrementalId, category, query, subject, from, room, dateTime}
    , (err) ->
      console.log err
      callback err

  # TODO: 命名は適切？
  _parse: (text, callback) ->
    mecab.parse @_removeSelfName(text), (err, parsedText) ->
      callback err, parsedText

  _removeSelfName: (text) ->
    # TODO: ハードコーディングをやめる。
    text.slice("kpt-chan: ".length)

  _getCategory: (parsedText) ->
    category = ''

    # TODO: より短く書けないか。
    _.each categoryWordMap, (categoryWords, categoryName) =>
      matched = _.some @_enteredWords(parsedText), (token) ->
        _.contains categoryWords, token
      category = categoryName if matched

    category

  # TODO: _getCategoryと同じロジックなのでDRYに。
  _getQuery: (parsedText) ->
    query = ''

    _.each queryWordMap, (queryWords, queryName) =>
      matched = _.some @_enteredWords(parsedText), (token) ->
        _.contains queryWords, token
      query = queryName if matched

    query

  _getSubject: (text) ->
    # TODO: そもそも後読みはできないが、もっと簡潔に書ける方法がないかを検討。
    tmp = text.match(/\".+\"/)
    return '' if _.isEmpty(tmp)
    tmp[0].replace(/\"/g, '')

  _getIncrementalId: (text) ->
    tmp = text.match(/id\:\d/)
    return '' if _.isEmpty(tmp)
    tmp[0].replace(/id\:/g, '')

  _getDateTime: (text) ->
    tmp = text.match(/\d{4}-\d{1,2}-\d{1,2}\s\d{2}\:\d{2}/)
    return null if _.isEmpty(tmp)
    moment(tmp[0]).local().toDate()

  _enteredWords: (msg) ->
    _.map msg, (array) -> array[0]


module.exports = MessageParser
