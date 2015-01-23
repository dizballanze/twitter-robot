mongoose = require 'mongoose'
Schema = mongoose.Schema


###
Schema of noticed user
###
NoticedUserSchema = new Schema
  username:
    type: String
    required: yes
    index: yes
  noticed_at:
    type: Date
    default: Date.now
  account:
    type: String
    required: yes
    index: yes

NoticedUserSchema.index {username: 1, account: 1}, {unique: yes}
NoticedUserSchema.set 'autoIndex', yes
NoticedUser = mongoose.model "NoticedUser", NoticedUserSchema
exports.NoticedUser = NoticedUser


###
Schema of favorite tweets
###
FavoriteTweetSchema = new Schema
  identifier:
    type: String
    required: yes
    index: yes
  created_at:
    type: Date
    default: Date.now
    index: yes
  is_removed:
    type: Boolean
    default: no
  account:
    type: String
    required: yes
    index: yes

FavoriteTweetSchema.index {identifier: 1, account: 1}, {unique: yes}
FavoriteTweetSchema.set 'autoIndex', yes
FavoriteTweet = mongoose.model "FavoriteTweet", FavoriteTweetSchema
exports.FavoriteTweet = FavoriteTweet