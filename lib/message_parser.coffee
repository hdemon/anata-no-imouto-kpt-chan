_ = require 'lodash'
_s = require 'underscore.string'
RSVP = require 'rsvp'

MeCab = new require('mecab-async')
mecab = new MeCab()

categoryWordMap = require './category_word_map'
queryWordMap = require './query_word_map'


class MessageParser
  parse: (msg, callback) ->
    category = ''
    query = ''
    subject = ''
    promises = []

    promises.push new RSVP.Promise (resolve, reject) =>
      @_parse msg, (result) =>
        category = @_getCategory result
        resolve()

    promises.push new RSVP.Promise (resolve, reject) =>
      @_parse msg, (result) =>
        query = @_getQuery result
        resolve()

    promises.push new RSVP.Promise (resolve, reject) =>
      subject = @_getSubject msg
      resolve()


    RSVP.all(promises).then ->
      callback null, {category, query, subject}
    , (err) ->
      callback err


  _parse: (msg, callback) ->
    mecab.parse msg, (err, result) ->
      throw err if err
      callback result

  _getCategory: (msg) ->
    category = ''

    # TODO: より短く書けないか。
    _.each categoryWordMap, (categoryWords, categoryName) =>
      matched = _.some @_enteredWords(msg), (token) ->
        _.contains categoryWords, token
      category = categoryName if matched

    category

  # TODO: _getCategoryと同じロジックなのでDRYに。
  _getQuery: (msg) ->
    query = ''

    _.each queryWordMap, (queryWords, queryName) =>
      matched = _.some @_enteredWords(msg), (token) ->
        _.contains queryWords, token
      query = queryName if matched

    query

  _getSubject: (msg) ->
    # TODO: 最初から"を取得せず、replaceが不要な正規表現を書く。
    msg.match(/\".+\"/)[0].replace(/\"/g, '')

  _enteredWords: (msg) ->
    _.map msg, (array) -> array[0]


module.exports = MessageParser
