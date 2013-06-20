CALLBACK_URL = "http://localhost:9393/oauth/callback"

get '/' do
  popular_media = Instagram.media_popular.first(9)
  @images = get_popular_images(popular_media)
  erb :index
end

get "/oauth/connect" do
  redirect Instagram.authorize_url(:redirect_uri => CALLBACK_URL)
end

get "/oauth/callback" do
  response = Instagram.get_access_token(params[:code], :redirect_uri => CALLBACK_URL)
  session[:access_token] = response.access_token
  user = Instagram.client(:access_token => session[:access_token]).user
  redirect "/user/#{user.username}/profile"
end

get '/user/:username/profile' do
  @client = Instagram.client(:access_token => session[:access_token]) if session[:access_token]

  if @client && @client.user.username == params["username"]
    @media = @client.user_recent_media
    @user = @client.user
  else
    @user = Instagram.user_search(params["username"]).pop
  end

  erb :user_profile
end


post '/' do
 redirect "/user/#{params["username"]}/profile"
end