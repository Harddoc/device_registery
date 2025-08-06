Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  
  post '/login', to: 'sessions#create'
  
  scope '/api' do
    post :assign, to: 'devices#assign'
    post :unassign, to: 'devices#unassign'
  end
end
