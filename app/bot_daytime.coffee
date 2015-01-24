###
Custom bot that supports rectriction by day time.
It can work only for specified period of the day.

You should specify properties `daytime_start` and `daytime_end` in config.coffee
for accounts that using this bot class.
###


moment = require 'moment'
Bot = require('./bot').Bot


class DaytimeBot extends Bot

  constructor: (config)->
    if not config.daytime_start? or not config.daytime_end
      throw new Error 'Should specify daytime_start and daytime_end params in config for DaytimeBot'
    @daytime_start = config.daytime_start
    @daytime_end = config.daytime_end
    super config

  is_valid: (tweet, cb)->
    # Check that current time is in range
    date_range = [
      moment().startOf('day').add(@daytime_start...)
      moment().startOf('day').add(@daytime_end...)]
    if not moment().isBetween(date_range...)
      return cb null, no
    super tweet, cb


module.exports.DaytimeBot = DaytimeBot