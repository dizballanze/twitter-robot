###
Bot logic
###
async = require 'async'
models = require './models'
NoticedUser = models.NoticedUser
FavoriteTweet = models.FavoriteTweet


class Bot

  constructor: (config)->
    @name = config.name
    @keywords = config.keywords or []
    @stopwords = config.stopwords or []
    @langs = config.langs or []

  is_valid: (tweet, cb)->
    # check stopwords
    if @_has_stopwords tweet.text
      return cb null, no, "stopword"
    # check language
    if @langs
      if tweet.lang == 'und'
        lang = tweet.user.lang
      else
        lang = tweet.lang
      if lang not in @langs
        return cb null, no, "lang"
    # check if user already noticed
    NoticedUser.findOne 
      username: tweet.user.screen_name
      account: @name
    , (err, user)->
      cb err, not user?, "user"

  process: (tweet, cb)->
    ###
    Save noticed user and favorite tweet to database
    ###
    async.parallel [
      (callback)=>
        user = new NoticedUser username: tweet.user.screen_name, account: @name
        user.save callback

      (callback)=>
        fav = new FavoriteTweet identifier: tweet.id_str, account: @name
        fav.save callback
    ], (err)->
      return cb err if cb
      if err and err.code == 11000
        console.log "duplicate key error"
      throw err if err and err.code != 11000  # ignore duplicate key errors

  get_keywords: ()->
    return @keywords

  _has_stopwords: (text) ->
    return false unless @stopwords.length
    lower_text = text.toLowerCase()
    for i of @stopwords
      return true  unless lower_text.indexOf(@stopwords[i]) is -1
    false

exports.Bot = Bot