module MusicApp
    module AuthHelper
        def authenticate_user!
            auth_header = headers['Authorization']
            error!({ error: 'Unauthorized' }, 401) unless auth_header
          
            # Extract the token from the "Bearer <token>" format
            token = auth_header.split(' ').last
            error!({ error: 'Unauthorized' }, 401) unless token
          
            begin
              decoded_token = JWT.decode(token, Rails.application.credentials.secret_key_base)[0]
              @current_user = User.find_by(id: decoded_token['user_id'])
              error!({ error: 'Unauthorized' }, 401) unless @current_user
            rescue JWT::ExpiredSignature
              error!({ error: 'Token has expired' }, 401)
            rescue JWT::DecodeError
              error!({ error: 'Invalid token' }, 401)
            end
          end
  
      def authorize_artist!
        error!({ error: 'Only artists are allowed to perform this action' }, 403) unless current_user.role == 'artist'
      end
  
      def current_user
        @current_user
      end
    end
  end