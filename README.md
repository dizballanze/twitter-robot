# Simple Twitter Fav Bot

Simple twitter bot originally based on [rfreebern/simple-twitter-bot](https://github.com/rfreebern/simple-twitter-bot).
Use twitter streams to watch for specified keywords and favorite tweets with them.
Has several useful features:
 -  Custom validation logic.
 -  Multiple accounts support (with separated properties).
 -  Stopwords lists.

## Usage

1. `git clone https://github.com/rfreebern/simple-twitter-bot.git && cd simple-twitter-bot && npm install`
2. Create an application on http://dev.twitter.com
3. Generate the necessary tokens.
4. Copy `config.js-dist` to `config.js`
5. Put your tokens in `config.js`
6. Put some keywords for your bot to follow in the `keywords` array in `config.js`
7. Add whatever logic you want to the `valid` function in `config.js`
8. `node bot.js > output.log &` or `forever start -o twi.out -l twi.log -e twi.err -a bot.js` (if you have forever installed)

## License

The person who associated a work with this deed has dedicated the work to the public domain by waiving all of his or her rights to the work worldwide under copyright law, including all related and neighboring rights, to the extent allowed by law.

You can copy, modify, distribute and perform the work, even for commercial purposes, all without asking permission.

[CC0](http://creativecommons.org/publicdomain/zero/1.0/)
