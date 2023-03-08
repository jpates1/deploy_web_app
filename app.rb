# file: app.rb
require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/album_repository'
require_relative 'lib/artist_repository'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/album_repository'
    also_reload 'lib/artist_repository'
  end


  get '/albums/new' do
    return erb(:new_album)
  end


  get '/albums' do
    repo = AlbumRepository.new
    @album = repo.all
    return erb(:index)
  end

  post '/albums' do

    if invalid_album_request_parameters?
      status 400
      return ''
    end

    repo = AlbumRepository.new
    new_album = Album.new
    new_album.title = params[:title]
    new_album.release_year = params[:release_year]
    new_album.artist_id = params[:artist_id]

    repo.create(new_album)
    return ''
  end

  get '/albums/:id' do
    repo = AlbumRepository.new
    artist_repo = ArtistRepository.new
    @album = repo.find(params[:id])
    @artist = artist_repo.find(@album.artist_id)
    return erb(:album)
  end
  
  get '/artists/new' do
    return erb(:new_artist)
  end

  get '/artists/:id' do
    repo = ArtistRepository.new
    @artist = repo.find(params[:id])
    return erb(:artist)
  end

  get '/artists' do
    repo = ArtistRepository.new
    @artist = repo.all
    return erb(:index_artists)
  end

  post '/artists' do

    if invalid_artist_request_parameters?
      status 400
      return ''
    end

    repo = ArtistRepository.new
    new_artist = Artist.new
    new_artist.name = params[:name]
    new_artist.genre = params[:genre]
    repo.create(new_artist)
    return ''
  end

  def invalid_album_request_parameters?
    return (params[:title] == nil || params[:release_year] == nil || params[:artist_id] == nil)
  end

  def invalid_artist_request_parameters?
    return (params[:name] == nil || params[:genre] == nil)
  end
end

  # get '/artists' do
  #   repo = ArtistRepository.new
  #   artists = repo.all

  #   response = artists.map do |artist|
  #     artist.name
  #   end.join(", ")

  # return response
  # end

  # post '/artists' do
  #   repo = ArtistRepository.new

  #   new_artist = Artist.new
  #   new_artist.name = params[:name]
  #   new_artist.genre = params[:genre]
  #   repo.create(new_artist)
  # end