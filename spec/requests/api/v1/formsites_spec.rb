require 'rails_helper'
RSpec.describe 'Formsites API', type: :request do

  # initialize test data 
  let!(:formsite1) { create(:formsite) }
  let!(:formsite2) { create(:formsite) }
  let!(:openposition) { create(:formsite, name: "openposition.us") }

  describe 'formsite users' do
    context "should create formsite user" do

      context "not verified formsite_user" do
        let(:post_params) {{user: {email: "test@test.test", first_name: "test", last_name: "test"}}}
        before { post add_user_api_v1_formsites_path(formsite1), params: post_params }

        it_behaves_like "Add formsite user success request"

        it "creates not verified formsite_user with user" do
          expect(json["is_verified"]).to eq(false)
          expect(json["formsite_user"]["is_duplicate"]).to eq(false)
          expect(json["formsite_user"]["is_email_duplicate"]).to eq(false)
        end

        it "creates ip_duplicate" do
          expect(json["formsite_user"]["is_duplicate"]).to eq(false)

          post_params = {user: {email: "test1@test.test", first_name: "test1", last_name: "test1"}}
          post add_user_api_v1_formsites_path(formsite1), params: post_params

          expect(json["formsite_user"]["is_duplicate"]).to eq(true)
          expect(json["formsite_user"]["is_email_duplicate"]).to eq(false)
        end

        it "creates email duplicate" do
          headers = { "REMOTE_ADDR" => "1.2.3.4" }
          post_params = {user: {email: "test@test.test", first_name: "test", last_name: "test"}}
          post add_user_api_v1_formsites_path(formsite1), params: post_params, headers: headers

          expect(json["is_verified"]).to eq(false)
          expect(json["formsite_user"]["is_duplicate"]).to eq(false)
          expect(json["formsite_user"]["is_email_duplicate"]).to eq(true)
        end

        it "not creates duplicates for different formsites" do
          post add_user_api_v1_formsites_path(formsite2), params: post_params

          expect(json["is_verified"]).to eq(false)
          expect(json["formsite_user"]["is_duplicate"]).to eq(false)
          expect(json["formsite_user"]["is_email_duplicate"]).to eq(false)
        end

      end

      context "extra darta" do
        it "creates user with extra data" do
          post_params = {user: {
            email: "test@test.test", first_name: "test", last_name: "test",
            s1: "s1", s2: "s2", s3: "s3", s4: "s4", s5: "s5",
            key: "key", phone: "phone", zip: "zip", birthday: "2018-10-09T15:47:15.000-05:00"
          }}
          post add_user_api_v1_formsites_path(formsite1), params: post_params
          formsite_user = json["formsite_user"]

          expect(json["user"]["email"]).to eq(post_params[:user][:email])

          expect(formsite_user["s1"]).to eq(post_params[:user][:s1])
          expect(formsite_user["s2"]).to eq(post_params[:user][:s2])
          expect(formsite_user["s3"]).to eq(post_params[:user][:s3])
          expect(formsite_user["s4"]).to eq(post_params[:user][:s4])
          expect(formsite_user["s5"]).to eq(post_params[:user][:s5])
          expect(formsite_user["phone"]).to eq(post_params[:user][:phone])
          expect(formsite_user["zip"]).to eq(post_params[:user][:zip])
          expect(formsite_user["birthday"]).to eq(post_params[:user][:birthday])
          expect(json["is_verified"]).to eq(false)
          expect(json["formsite_user"]["is_duplicate"]).to eq(false)
          expect(json["formsite_user"]["is_email_duplicate"]).to eq(false)
        end

      end

      context "empty formsite user" do
        it "creates empty formsite user" do
          post_params = {"user":{"first_name":"","last_name":"","email":"","ndm_token":"taTcWeU0TRSwbZYSgIpGn3ny","a":"openposition"}}
          post add_user_api_v1_formsites_path(formsite1), params: post_params

          expect(json["user"]).to eq(nil)
          expect(json["is_verified"]).to eq(false)
          formsite_user = json["formsite_user"]

          expect(formsite_user["user_id"]).to eq(nil)
          expect(formsite_user["formsite_id"]).to eq(formsite1.id)
          expect(formsite_user["affiliate"]).to eq("openposition")
        end

        it "do not create empty user with the same IP" do
          post_params = {"user":{"first_name":"","last_name":"","email":"","ndm_token":"taTcWeU0TRSwbZYSgIpGn3ny","a":"openposition"}}
          post add_user_api_v1_formsites_path(formsite1), params: post_params
          
          formsite_user = json["formsite_user"]
          
          post add_user_api_v1_formsites_path(formsite1), params: post_params
          
          formsite_user1 = json["formsite_user"]

          expect(formsite_user["id"]).to eq(formsite_user1["id"])
        end

        it "creates empty formsite user with affiliates" do
          post_params = {"user":{"first_name":"","last_name":"","email":"","ndm_token":"taTcWeU0TRSwbZYSgIpGn3ny","a":"openposition", "s1": "s1", "s2": "s2", "s3": "s3", "s4": "s4", "s5": "s5", "key": "job_key"}}
          
          post add_user_api_v1_formsites_path(formsite1), params: post_params

          formsite_user = json["formsite_user"]

          expect(formsite_user["s1"]).to eq(post_params[:user][:s1])
          expect(formsite_user["s2"]).to eq(post_params[:user][:s2])
          expect(formsite_user["s3"]).to eq(post_params[:user][:s3])
          expect(formsite_user["s4"]).to eq(post_params[:user][:s4])
          expect(formsite_user["s5"]).to eq(post_params[:user][:s5])
          expect(formsite_user["job_key"]).to eq(post_params[:user][:key])
          
        end
      end

      context "verified formsite user" do
        let(:post_params) {{user: {email: "denissalaev@gmail.com", first_name: "Denis", last_name: "Salaev"}}}
        before { post add_user_api_v1_formsites_path(formsite1), params: post_params }

        it_behaves_like "Add formsite user success request"     

        it "creates verified formsite_user with user" do
          expect(json["is_verified"]).to eq(true)
          expect(json["formsite_user"]["is_duplicate"]).to eq(false)
          expect(json["formsite_user"]["is_email_duplicate"]).to eq(false)
        end

        it "creates ip duplicate" do
          formsite_user = json["formsite_user"]
          post_params = {user: {email: "denissalaev1@gmail.com", first_name: "Denis", last_name: "Salaev"}}
          post add_user_api_v1_formsites_path(formsite1), params: post_params
          formsite_user1 = json["formsite_user"]

          expect(json["is_verified"]).to eq(false)
          expect(json["formsite_user"]["is_duplicate"]).to eq(true)
          expect(json["formsite_user"]["is_email_duplicate"]).to eq(false)
        end

        it "creates email duplicate" do
          headers = { "REMOTE_ADDR" => "1.2.3.4" }

          formsite_user = json["formsite_user"]
          post add_user_api_v1_formsites_path(formsite1), params: post_params, headers: headers
          formsite_user1 = json["formsite_user"]

          # TODO: Check this behaviour
          expect(json["is_verified"]).to eq(true)
          expect(json["formsite_user"]["is_duplicate"]).to eq(false)
          expect(json["formsite_user"]["is_email_duplicate"]).to eq(true)
        end
      end

      context "empty user" do
        it "fill empty user by IP" do
          post_params = {"user":{"first_name":"","last_name":"","email":"","ndm_token":"taTcWeU0TRSwbZYSgIpGn3ny","a":"openposition", "s1": "s1", "s2": "s2", "s3": "s3", "s4": "s4", "s5": "s5", "key": "job_key"}}
          post add_user_api_v1_formsites_path(formsite1), params: post_params
          formsite_user = json["formsite_user"]

          filled_params = {user: {email: "denissalaev@gmail.com", first_name: "Denis", last_name: "Salaev"}}
          post add_user_api_v1_formsites_path(formsite1), params: filled_params
          formsite_user1 = json["formsite_user"]

          expect(formsite_user["id"]).to eq(formsite_user1["id"])

          filled_params = {user: {email: "denissalaev1@gmail.com", first_name: "Denis", last_name: "Salaev"}}
          post add_user_api_v1_formsites_path(formsite1), params: filled_params
          formsite_user2 = json["formsite_user"]
          expect(formsite_user["id"]).not_to eq(formsite_user2["id"])
        end
      end
    end
  end
end