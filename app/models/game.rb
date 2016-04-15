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

  def check_letter letter
    if self.status == :busy
      unless self.guessed_letters.include? letter 
        self.guessed_letters << letter # push to array
        if self.word.split("").include? letter 
          if self.success?
            self.status = :success
          end
        else
          self.tries_left -= 1
          if self.failed?
            self.status = :fail
          end
        end
        self.save!
      end
    end
  end

  def success? placeholder = "."
    !self.return_word.include? placeholder
  end

  def failed?
    self.tries_left <= 0
  end

end