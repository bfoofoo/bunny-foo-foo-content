class Api::V1::ApiUsersController < ApiController
  before_action :authenticate, only: [:create, :update]
end
