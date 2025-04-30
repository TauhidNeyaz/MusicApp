module MusicApp
    module V1
      class Auth < Grape::API
        prefix 'api'
        version 'v1', using: :path
        format :json
  
        resource :auth do
          desc 'User Signup'
          params do
            requires :email, type: String
            requires :password, type: String
            requires :name, type: String
            optional :profile_photo, type: String
            optional :role, type: String, values: ['artist', 'listener']
          end
          post :signup do
            role = params[:role] || 'listener' # default role
  
            if User.find_by(email: params[:email])
              error!({ error: 'Email already taken' }, 422)
            end
  
            user = User.new(
              email: params[:email],
              name: params[:name],
              role: role,
              profile_photo: params[:profile_photo],
              password: params[:password]
            )
  
            if user.save
              { message: 'Signup successful', user_id: user.id }
            else
              error!({ error: user.errors.full_messages }, 422)
            end
          end
  
          desc 'User Login'
          params do
            requires :email, type: String
            requires :password, type: String
          end
          post :login do
            user = User.find_by(email: params[:email])
  
            if user && user.authenticate(params[:password])
              expiration_time = Time.now.to_i + 24 * 3600 # 24 hours
              payload = { user_id: user.id, exp: expiration_time }
              token = JWT.encode(payload, Rails.application.credentials.secret_key_base)
              { token: token, message: 'Login successful' }
            else
              error!({ error: 'Invalid email or password' }, 401)
            end
          end
        end
      end
    end
  end
  