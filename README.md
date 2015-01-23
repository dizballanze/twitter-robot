# Twitter Robot

Twitter bot originally based on [rfreebern/simple-twitter-bot](https://github.com/rfreebern/simple-twitter-bot).
Use twitter streams to watch for specified keywords and favorite tweets with them.
Has several useful features:
 -  Custom validation logic.
 -  Multiple accounts support (with separated properties).
 -  Stopwords lists.
 -  Limitations by user who was favorited.
 -  Unfavorite tweets in specified amount of time.

## Usage

1. `git clone https://github.com/dizballanze/twitter-robot.git && cd twitter-robot && npm install`
2. Create an application on http://dev.twitter.com
3. Generate the necessary tokens.
4. Copy `app/config-example.coffee` to `app/config.coffee`
5. Put your tokens in `app/config.coffee`
6. Put some keywords for your bot to follow in the `keywords` array in `app/config.coffee`
7. Put some stopwords for your bot to filter in the `stopwords` array in `app/config.coffee`
8. `bin/bot > output.log &` or `forever start -o twi.out -l twi.log -e twi.err -a bin/bot` (if you have forever installed)
9. To customize bot logic you can override default `Bot` class and specify it as `bot_class` in `app/config.coffee`

OR to use twitter-bot on local machine:

```
vagrant up
vagrant ssh
```

(you should have installed vagrant, ansible and virtualbox)

## License

The MIT License (MIT)

Copyright (c) 2015 Yuri Shikanov