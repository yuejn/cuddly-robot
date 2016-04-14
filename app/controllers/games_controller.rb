class GamesController < ApplicationController

  before_action :set_game, only: [:show, :update]

  def index # GET: games
    @games = Game.all
  end

  def create # POST: games
    @game = Game.create(
      word: Faker::Hipster.word,
      guessed_letters: [],
      status: :busy
    )
  end

  def show # GET: games/:id
  end

  def update # PATCH: games/:id
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end

end