require 'sinatra'
require 'sinatra/reloader'

require './mastermind'

configure do
  enable :sessions
end


get '/' do
  if session[:secret_code].nil?
    redirect to('/newgame')
  else
    if session[:results_hash].size >= 12
      redirect to('/lose')
    else
      @history_hash = session[:results_hash]
      @turn = session[:results_hash].size

      erb :main_view
    end
  end
end

post '/' do
  result = move_result(params["guess"])
  session[:results_hash][params["guess"]] = result

  check_win(result)

  redirect to('/')
end

get '/newgame' do
  session[:secret_code] = rand_code
  session[:results_hash] = Hash.new

  redirect to('/')
end

get '/win' do
  @message = "Congratufuckinglations, you cracked the code!"

  erb :win
end

get '/lose' do
  @message = "CongratuNOTfuckinglations, you lost..."

  @secret_code = session[:secret_code]
  @history_hash = session[:results_hash]

  erb :lose
end

get '/rules' do
  erb :rules
end
