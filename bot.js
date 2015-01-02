var Twit = require('twit');
var Config = require('./config.js');

if (Config.debug) {
    console.log("In debug mode.");
}

function has_stopwords(word, stopwords) {
    if (!stopwords.length) {
        return false;
    }
    lower_word = word.toLowerCase();
    for (var i in stopwords) {
        if (lower_word.indexOf(stopwords[i]) != -1) {
            return true;
        }
    }
    return false;
}

for (var i in Config.accounts) {
    (function(conf) {
        var T = new Twit({
            consumer_key: conf.consumer_key,
            consumer_secret: conf.consumer_secret,
            access_token: conf.access_token,
            access_token_secret: conf.access_token_secret
        });

        var stream = T.stream('statuses/filter', { track: conf.keywords.join(',') });
        stream.on('tweet', function (tweet) {
            var now = new Date();
            if (conf.valid(tweet) && !has_stopwords(tweet.text, conf.stopwords)) {
                if (!Config.debug) {
                    T.post('favorites/create', { id: tweet.id_str }, function (err, reply) {
                        if (err) {
                            // Ignore errors about reached limits
                            if (err.statusCode != 429) {
                                console.log(conf.name, err);
                            }
                        } else {
                            console.log('[' + now.toJSON() + '] #' + tweet.id + ' is favorited by ' + conf.name);
                        }
                    });
                } else {
                    console.log('[' + now.toJSON() + '] #' + tweet.id + ' is favorited by ' + conf.name);
                }
            } else {
                console.log('[' + now.toJSON() + '][' + conf.name + '] INVALID: @' + tweet.user.screen_name + ':' + tweet.text);
            }
        });

        stream.on('warning', function (item) { console.log('WARNING [' + conf.name + ']: ' + item); });
        stream.on('disconnect', function (item) { console.log('Stream disconnected [' + conf.name + '].'); });
        stream.on('connect', function (item) { console.log('Stream connected [' + conf.name + '].'); });
        stream.on('reconnect', function (item) { console.log('Stream reconnected [' + conf.name + '].'); });
    })(Config.accounts[i])
}