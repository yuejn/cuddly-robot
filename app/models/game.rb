class Game
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Enum

  field :word, type: String
  field :guessed_letters, type: Array
  field :tries_left, type: Integer, default: 11
  enum :status, [:busy, :fail, :success]

end
