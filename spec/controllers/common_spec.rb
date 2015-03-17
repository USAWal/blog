require 'rails_helper'

RSpec.describe 'route to root', type: :routing do
  describe 'GET /' do
    it 'routes to articles index' do
      expect(get '/').to route_to 'articles#index'
    end
  end
end
