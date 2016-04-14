class Game
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Enum

  field :word, type: String
  field :guessed_letters, type: Array
  field :tries_left, type: Integer, default: 11
  enum :status, [:busy, :fail, :success]

  before_create :normalize_word

  def normalize_word
    self.word = self.word.downcase.gsub(/[[:punct:]]/, "")
  end

  def return_word placeholder = "."
    display = ""

    self.word.chars do |letter|
       display += (self.guessed_letters.include? letter) ? letter : placeholder
    end

    display
  end

end