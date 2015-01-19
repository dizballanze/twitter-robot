module.exports =
  debug: false
  accounts: [
    name: "example"
    consumer_key: ""
    consumer_secret: ""
    access_token: ""
    access_token_secret: ""
    keywords: []
    stopwords: [] # lowercase
    valid: (tweet) ->
      true
  ]