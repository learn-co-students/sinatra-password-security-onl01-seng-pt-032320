require "./config/environment"
require "./app/models/user"
class ApplicationController < Sinatra::Base

	configure do
		set :views, "app/views"
		enable :sessions
		set :session_secret, "password_security"
	end

	get "/" do
		erb :index
	end

	get "/signup" do
		erb :signup
	end

	post "/signup" do
		user = User.new(:username => params[:username], :password => params[:password])
		if user.save
			redirect "/login"
		else
			redirect "/failure"
		end
	end

	get "/login" do
		erb :login
	end

	post "/login" do
		user = User.find_by(:username => params[:username])
		if user && user.authenticate(params[:password])
			puts "You made it!!!!"
			puts user.id
			session[:id] = user.id
			session[:username] = user.username
			puts session[:id]
			redirect "/success"
		else
			redirect "failure"
		end
	end

	get "/success" do
		if logged_in?
			puts "you are loggted in !!!!@@@@@"
			@user = session[:username]
			erb :success
		else
			redirect "/login"
		end
	end

	get "/failure" do
		erb :failure
	end

	get "/logout" do
		session.clear
		redirect "/"
	end

	helpers do
		def logged_in?
			puts !!session[:id]
			!!session[:id]
			
		end

		def current_user
			@user ||=User.find_by_id(session[:user_id]) if logged_in?
		end
	end

end
