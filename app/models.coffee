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
    unique: yes
  noticed_at:
    type: Date
    default: Date.now

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
    unique: yes
  created_at:
    type: Date
    default: Date.now
    index: yes
  is_removed:
    type: Boolean
    default: no

FavoriteTweetSchema.set 'autoIndex', yes
FavoriteTweet = mongoose.model "FavoriteTweet", FavoriteTweetSchema
exports.FavoriteTweet = FavoriteTweet