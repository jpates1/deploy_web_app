require "spec_helper"
require "rack/test"
require_relative '../../app'

DatabaseConnection.connect

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  context "GET /albums" do
    it "gives a link to click through to album details" do
      response = get('/albums')
      expect(response.status).to eq(200)
      expect(response.body).to include("<a href=\"/albums/12\">Ring Ring</a><br />\n")
      expect(response.body).to include("<a href=\"/albums/2\">Surfer Rosa</a><br />\n")
      expect(response.body).to include("<a href=\"/albums/3\">Waterloo</a><br />\n")
    end
  end

  context "GET /albums/new" do
    it "Should return the form to add album" do
      response = get ('/albums/new')
      expect(response.status).to eq (200)
      expect(response.body).to include('<h1>Add an album</h1>')
      # Assert we have the correct form tag with the action and method.
      expect(response.body).to include('<form method="POST" action="/albums"')
      expect(response.body).to include('<input type="text" name="title" />')
      expect(response.body).to include('<input type="text" name="release_year" />')
      expect(response.body).to include('<input type="text" name="artist_id" />')
    end
  end
  
  context "GET /albums/:id" do
    it "returns content for album one'" do
      response = get('/albums/2')
      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Surfer Rosa</h1>')
      expect(response.body).to include('Release year: 1988')
      expect(response.body).to include('Artist: Pixies')
    end
  end
  
  context "POST /albums" do
    it "should validate album parameters" do
      response = post(
        '/albums',
        invalid_album_title: "Umbrella",
        invalid_release_year: "2000",
        invalid_artist_id: "4")
      expect(response.status).to eq (400)
      end

    it "Should create an album" do
      response = post(
        '/albums',
        title: "Umbrella",
        release_year: "2000",
        artist_id: "4")
      expect(response.status).to eq (200)
      expect(response.body).to include('')

      response = get('/albums')
      expect(response.body).to include("Umbrella")
    end

    it "Should create a different album" do
      response = post(
        '/albums',
        title: "Tomorrow",
        release_year: "2001",
        artist_id: "5")
      expect(response.status).to eq (200)
      expect(response.body).to include('')

      response = get('/albums')
      expect(response.body).to include("Tomorrow")
    end
  end

  context "GET /artists" do
    it "gives a link to click through to album details" do
      response = get('/artists')
      expect(response.status).to eq(200)
      expect(response.body).to include("<a href=\"/albums/1\">Pixies</a><br />\n")
      expect(response.body).to include("<a href=\"/albums/2\">ABBA</a><br />\n")
      expect(response.body).to include("<a href=\"/albums/3\">Taylor Swift</a><br />\n")
    end
  end

  context "GET /artists/new" do
    it "Should return the form to add artist" do
      response = get ('/artists/new')
      expect(response.status).to eq (200)
      expect(response.body).to include('<h1>Add an artist</h1>')
      # Assert we have the correct form tag with the action and method.
      expect(response.body).to include('<form method="POST" action="/artists"')
      expect(response.body).to include('<input type="text" name="name" />')
      expect(response.body).to include('<input type="text" name="genre" />')
      
    end
  end

  context "GET /artists/:id" do
    it "returns content for artist one'" do
      response = get('/artists/2')
      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>ABBA</h1>')
      expect(response.body).to include('Genre: Pop')
      expect(response.body).to include('ID: 2')
    end
  end

  context "POST /artists" do
    it "should validate artist parameters" do
      response = post(
        '/artists',
        invalid_name: "Kano",
        invalid_genre: "2000",)
      expect(response.status).to eq (400)
      end

    it "Should create an artist" do
      response = post(
        '/artists',
        name: "Kano",
        genre: "Grime",
      )
      expect(response.status).to eq (200)
      expect(response.body).to include('')

      response = get('/artists')
      expect(response.body).to include("Kano")
    end

    it "Should create a different artist" do
      response = post(
        '/artists',
        name: "Ghetts",
        genre: "Grime",
      )
      expect(response.status).to eq (200)
      expect(response.body).to include('')

      response = get('/artists')
      expect(response.body).to include("Ghetts")
    end
  end
end

#OLD OLD OLD
# context "GET /artists" do
#   it "gets a list of artist names" do
#     response = get('/artists')

#     expected_response = "Pixies, ABBA, Taylor Swift, Nina Simone, Kiasmos"

#     expect(response.status).to eq (200)
#     expect(response.body).to eq (expected_response)
#   end
# end

# context "POST /artists" do
#   it "gets a list of artist names" do
#     response = post('/artists', name: "Elton John", genre: "Pop")
#     response = get('artists')
#     expect(response.status).to eq (200)
#     expect(response.body).to include("Elton John")
#   end
# end