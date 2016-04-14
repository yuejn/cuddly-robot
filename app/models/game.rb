class Game
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Enum

  field :word, type: String
  field :guessed_letters, type: Array
  field :tries_left, type: Integer, default: 11
  enum :status, [:busy, :fail, :success]

  before_create :normalize_word
  after_update :check_and_update_status

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

  def check_letter letter
    if self.status == :busy
      unless self.guessed_letters.include? letter 
        self.guessed_letters << letter # push to array
        unless self.word.split("").include? letter 
          self.tries_left -= 1
        end
        self.save!
      end
    end
  end

  def check_and_update_status
    if self.tries_left == 0
      self.update(status: :fail)
    else
    end
  end

end