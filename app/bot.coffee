###
Bot logic
###


class Bot

  constructor: (@debug, config)->
    @name = config.name
    @keywords = config.keywords
    @stopwords = config.stopwords

  is_valid: (tweet, cb)->
    # validate
    # check if user already noticed
    # check if tweet already favorited
    # check stopwords

  process: (tweet, cb)->
    # add tweet and user to database

  get_keywords: ()->
    return @keywords

exports.Bot = Bot