module MusicApp
    module V1
        class SubscriptionRoute < Grape::API
            prefix 'api'
            version 'v1', using: :path
            format :json

            helpers MusicApp::AuthHelper 

            namespace :subscription do
                before do
                    authenticate_user! 
                end

                desc 'Subscribe to a music artist'
                params do 
                    requires :artist_id, type: Integer
                end

                post :subscribe do
                    artist = User.find_by(id: params[:artist_id], role: 'artist')
                    error!({ error: 'Artist not found' }, 404) unless artist

                    if current_user.role != 'listener'
                        error!({ error: 'Only listeners can subscribe to artists' }, 403)
                    end

                    # Check if the user is already subscribed to the artist
                    existing_subscription = Subscription.find_by(listener_id: current_user.id, artist_id: artist.id)
                    if existing_subscription
                        error!({ error: 'Already subscribed to this artist' }, 422)
                    end

                    subscription = Subscription.new(listener_id: current_user.id, artist_id: artist.id)

                    if subscription.save
                        { message: 'Subscription successful', subscription: subscription }
                    else
                        error!({ error: subscription.errors.full_messages }, 422)
                    end
                end  


                desc 'Unsubscribe from a music artist'
                params do 
                    requires :artist_id, type: Integer
                end

                delete :unsubscribe do
                    artist = User.find_by(id: params[:artist_id], role: 'artist')
                    error!({ error: 'Artist not found' }, 404) unless artist

                    if current_user.role != 'listener'
                        error!({ error: 'Only listeners can unsubscribe from artists' }, 403)
                    end

                    # Check if the user is subscribed to the artist
                    subscription = Subscription.find_by(listener_id: current_user.id, artist_id: artist.id)
                    unless subscription
                        error!({ error: 'Not subscribed to this artist' }, 422)
                    end

                    if subscription.destroy
                        { message: 'Unsubscription successful' }
                    else
                        error!({ error: 'Failed to unsubscribe' }, 422)
                    end
                end 

                desc 'Get all subscriptions of the current listener'
                get :my_subscriptions do
                    if current_user.role != 'listener'
                        error!({ error: 'Only listeners can view subscriptions' }, 403)
                    end

                    subscriptions = Subscription.where(listener_id: current_user.id)
                    artists = subscriptions.map { |s| User.find_by(id: s.artist_id) }

                    { listener: current_user.name, subscriptions: artists }
                end

                desc 'Get all listeners of the current artist'
                get :my_listeners do
                    if current_user.role != 'artist'
                        error!({ error: 'Only artists can view listeners' }, 403)
                    end

                    subscriptions = Subscription.where(artist_id: current_user.id)
                    listeners = subscriptions.map { |s| User.find_by(id: s.listener_id) }

                    { artist: current_user.name, listeners: listeners }
                end
            end
        end
    end
end