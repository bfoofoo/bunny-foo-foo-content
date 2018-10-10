require 'rails_helper'

RSpec.shared_examples "Add formsite user success request" do
  it {expect(response).to have_http_status(200)}
  it {expect(json["user"]["email"]).to eq(post_params[:user][:email])}
end