Rails.application.routes.draw do

  devise_for :users, :skip => [:sessions], :controllers => { :registrations => 'users/registrations' }
  #devise_for :users, :skip => [:sessions]

  
  devise_scope :user do
    get "/register" => "devise/registrations#new"
  end

end
