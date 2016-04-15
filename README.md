# Brief

Implement a minimal version of a hangman application using the API spec outlined below:

* `POST` `/games` Start a new game
* `GET` `/games` Overview of all games
* `GET` `/games/{id}` JSON response should include:
    * *word* (full stops for letters that have not yet been guessed);
    * *tries_left* (the number of tries left to guess, starts at 11);
    * *status* (busy, fail, success)
* `PATCH` `/games/{id}` Guessing a letter, POST body: *char=a* 

__Notes:__
* Guessing a correct letter doesn't decrement the amount of tries left;
* Only valid characters are a-z (lowercase).

Testing with [https://www.getpostman.com/](Postman)

## Proposal

### Gems

    gem 'rails', '4.2.6'
    gem 'thin'
    gem 'mongoid'
    gem 'mongoid-enum'
    gem 'faker'
    gem 'rabl'
    
* MongoDB
    * `rails g mongoid:config`
    * Start `mongod`

### Model: `game`

* `word` String
* `guessed_letters` Array
* `tries_left` Integer
* `status` Enum `[:busy, :fail, :success]`

### Controller: `application`

Update for API:

    protect_from_forgery with: :null_session
    
### Controller: `games` 

* `GET` `index` Retrieve list of games
* `POST` `create` Create a new game
* `GET` `show` Retrieves a game by ID 
* `PATCH` `update` Plays a game with `?char=a`

### Views: `/games`

* `index.json.rabl`
* `create.json.rabl`
* `show.json.rabl`
* `update.json.rabl`

... have some variation of:

    collection @game
    attributes :id, :return_word, :guessed_letters, :tries_left, :status

### Routes

    resources :games, only: [:index, :create, :show, :edit, :update]


## Runthrough

* Set up project;
* Set up MongoDB;
* Set up `Game` model and `games` controller;
* Logic:
    * Create a new game with a random word from `Faker::Hipster` dictionary;
    * Clean and replace the word (lowercase, remove punctuation) with `normalize_word`;
    * In the JSON response, return:
        * `return_word`, the blank word to be solved with letters replaced with a placeholder;
        *  `tries_left`, default is 11;
        *  `status`, default `:busy` (game in progress);
    * Player guesses a letter:
        * If there are tries left:
            * Check that the letter is valid;
            * Check that the letter hasn't been guessed before;
            * Add the letter to the list of guessed letters;
            * If the letter is successful, check if all letters have been found;
                * If the word has been found, set `status` to `:success` 
            * If the letter is unsuccessful, decrement the `tries_left` counter;
                * If there are no more tries, set `status` to `:fail`;   
    * Player can view a list of all games through `GET` `games`.