require 'rails_helper'
describe 'LeadgenRevSites API', type: :request do

  let!(:leadgen_rev_site1) { create(:leadgen_rev_site) }
  let!(:leadgen_rev_site2) { create(:leadgen_rev_site) }

  describe '#add_leadgen_rev_site_user' do

    context "given not verified lrs user" do
      let(:post_params) do
        {
          user: {
            email: "test@test.test",
            first_name: "test",
            last_name: "test"
          }
        }
      end
      before { post add_user_api_v1_leadgen_rev_site_path(leadgen_rev_site1), params: post_params }

      it_behaves_like "Add leadgen rev site user success request"

      it "creates not verified leadgen_rev_site_user with user" do
        post_params = { user: { email: "unsaidxpl@gmail.com", first_name: "Egor", last_name: "Romanov" } }
        post add_user_api_v1_leadgen_rev_site_path(leadgen_rev_site1), params: post_params
        expect(json["leadgen_rev_site_user"]["is_verified"]).to eq(false)
      end

      it "creates not verified leadgen_rev_site_user with empty name" do
        expect(json["is_verified"]).to eq(false)
        expect(json["leadgen_rev_site_user"]["is_duplicate"]).to eq(false)
        expect(json["leadgen_rev_site_user"]["is_email_duplicate"]).to eq(false)
      end

      it "creates ip_duplicate" do
        expect(json["leadgen_rev_site_user"]["is_duplicate"]).to eq(false)

        post_params = { user: { email: "test1@test.test", first_name: "test1", last_name: "test1" } }
        post add_user_api_v1_leadgen_rev_site_path(leadgen_rev_site1), params: post_params

        expect(json["leadgen_rev_site_user"]["is_duplicate"]).to eq(true)
        expect(json["leadgen_rev_site_user"]["is_email_duplicate"]).to eq(false)
      end

      it "creates email duplicate" do
        headers = { "REMOTE_ADDR" => "1.2.3.4" }
        post_params = { user: { email: "test@test.test", first_name: "test", last_name: "test" } }
        post add_user_api_v1_leadgen_rev_site_path(leadgen_rev_site1), params: post_params, headers: headers

        expect(json["is_verified"]).to eq(false)
        expect(json["leadgen_rev_site_user"]["is_duplicate"]).to eq(false)
        expect(json["leadgen_rev_site_user"]["is_email_duplicate"]).to eq(true)
      end

      it "not creates duplicates for different leadgen_rev_sites" do
        post add_user_api_v1_leadgen_rev_site_path(leadgen_rev_site2), params: post_params

        expect(json["is_verified"]).to eq(false)
        expect(json["leadgen_rev_site_user"]["is_duplicate"]).to eq(false)
        expect(json["leadgen_rev_site_user"]["is_email_duplicate"]).to eq(false)
      end

    end

    context "given extra data" do
      let(:post_params) do
        {
          user: {
            email: "test@test.test",
            first_name: "test",
            last_name: "test",
            s1: "s1",
            s2: "s2",
            s3: "s3",
            s4: "s4",
            s5: "s5",
            key: "key",
            phone: "phone",
            zip: "zip",
            birthday: "2018-10-09T15:47:15.000-05:00"
          }
        }
      end
      it "creates user with extra data" do
        post add_user_api_v1_leadgen_rev_site_path(leadgen_rev_site1), params: post_params
        leadgen_rev_site_user = json["leadgen_rev_site_user"]

        expect(leadgen_rev_site_user).to include(post_params[:user].slice('email', 's1', 's2', 's3', 's4', 's5', 'phone', 'zip', 'birthday'))
        expect(json["is_verified"]).to eq(false)
        expect(json["leadgen_rev_site_user"]["is_duplicate"]).to eq(false)
        expect(json["leadgen_rev_site_user"]["is_email_duplicate"]).to eq(false)
      end

    end

    context "given empty lrs user" do
      let(:post_params) do
        {
          "user":
            {
              "first_name": "",
              "last_name": "",
              "email": "",
              "ndm_token": "taTcWeU0TRSwbZYSgIpGn3ny",
              "a": "openposition"
            }
        }
      end
      it "creates empty leadgen_rev_site user" do
        post add_user_api_v1_leadgen_rev_site_path(leadgen_rev_site1), params: post_params

        expect(json["user"]).to eq(nil)
        expect(json["is_verified"]).to eq(false)
        leadgen_rev_site_user = json["leadgen_rev_site_user"]

        expect(leadgen_rev_site_user["user_id"]).to eq(nil)
        expect(leadgen_rev_site_user["leadgen_rev_site_id"]).to eq(leadgen_rev_site1.id)
        expect(leadgen_rev_site_user["affiliate"]).to eq("openposition")
      end

      it "do not create empty user with the same IP" do
        post add_user_api_v1_leadgen_rev_site_path(leadgen_rev_site1), params: post_params
        leadgen_rev_site_user = json["leadgen_rev_site_user"]

        post add_user_api_v1_leadgen_rev_site_path(leadgen_rev_site1), params: post_params
        leadgen_rev_site_user1 = json["leadgen_rev_site_user"]

        expect(leadgen_rev_site_user["id"]).to eq(leadgen_rev_site_user1["id"])
      end

      it "creates empty leadgen_rev_site user with affiliates" do
        post_params = {
          "user":
            { "first_name": "",
              "last_name": "",
              "email": "",
              "ndm_token": "taTcWeU0TRSwbZYSgIpGn3ny",
              "a": "openposition",
              "s1": "s1",
              "s2": "s2",
              "s3": "s3",
              "s4": "s4",
              "s5": "s5",
              "key": "job_key"
            }
        }

        post add_user_api_v1_leadgen_rev_site_path(leadgen_rev_site1), params: post_params
        leadgen_rev_site_user = json["leadgen_rev_site_user"]

        expect(leadgen_rev_site_user).to include(post_params[:user].slice('s1', 's2', 's3', 's4', 's5'))
        expect(leadgen_rev_site_user["job_key"]).to eq(post_params[:user][:key])

      end
    end

    context "given verified lrs user" do
      let(:post_params) do
        {
          user: {
            email: "unsaidxpl@gmail.com",
            first_name: "Egor",
            last_name: "Romanov"
          }
        }
      end
      before { post add_user_api_v1_leadgen_rev_site_path(leadgen_rev_site1), params: post_params }

      it_behaves_like "Add leadgen rev site user success request"

      it "creates verified leadgen_rev_site_user with user" do
        expect(json["is_verified"]).to eq(true)
        expect(json["leadgen_rev_site_user"]["is_duplicate"]).to eq(false)
        expect(json["leadgen_rev_site_user"]["is_email_duplicate"]).to eq(false)
      end

      it "creates ip duplicate" do
        post_params[:user][:email] = "unsaidxpl1@gmail.com"
        post add_user_api_v1_leadgen_rev_site_path(leadgen_rev_site1), params: post_params

        expect(json["is_verified"]).to eq(false)
        expect(json["leadgen_rev_site_user"]["is_duplicate"]).to eq(true)
        expect(json["leadgen_rev_site_user"]["is_email_duplicate"]).to eq(false)
      end

      it "getting IP from post params" do
        post_params[:user][:ip] = "192.168.0.1"
        post add_user_api_v1_leadgen_rev_site_path(leadgen_rev_site1), params: post_params
        leadgen_rev_site_user = json["leadgen_rev_site_user"]

        expect(leadgen_rev_site_user["ip"]).to eq(post_params[:user][:ip])
      end

      it "creates email duplicate" do
        headers = { "REMOTE_ADDR" => "1.2.3.4" }

        post add_user_api_v1_leadgen_rev_site_path(leadgen_rev_site1), params: post_params, headers: headers

        # TODO: Check this behaviour
        expect(json["is_verified"]).to eq(true)
        expect(json["leadgen_rev_site_user"]["ip"]).to eq("1.2.3.4")
        expect(json["leadgen_rev_site_user"]["is_duplicate"]).to eq(false)
        expect(json["leadgen_rev_site_user"]["is_duplicate"]).to eq(false)
        expect(json["leadgen_rev_site_user"]["is_email_duplicate"]).to eq(true)
      end
    end

    context "empty user" do
      let(:post_params) do
        { "user":
            { "first_name": "",
              "last_name": "",
              "email": "",
              "ndm_token": "taTcWeU0TRSwbZYSgIpGn3ny",
              "a": "openposition",
              "s1": "s1",
              "s2": "s2",
              "s3": "s3",
              "s4": "s4",
              "s5": "s5",
              "key": "job_key"
            }
        }
      end
      let(:filled_params) { {user: {email: "unsaidxpl@gmail.com", first_name: "Egor", last_name: "Romanov"}} }
      it "fill empty user by IP" do
        post add_user_api_v1_leadgen_rev_site_path(leadgen_rev_site1), params: post_params
        leadgen_rev_site_user = json["leadgen_rev_site_user"]

        post add_user_api_v1_leadgen_rev_site_path(leadgen_rev_site1), params: filled_params
        leadgen_rev_site_user1 = json["leadgen_rev_site_user"]

        expect(leadgen_rev_site_user["id"]).to eq(leadgen_rev_site_user1["id"])

        post add_user_api_v1_leadgen_rev_site_path(leadgen_rev_site1), params: filled_params.merge(email: "unsaidxpl1@gmail.com")
        leadgen_rev_site_user2 = json["leadgen_rev_site_user"]

        expect(leadgen_rev_site_user["id"]).not_to eq(leadgen_rev_site_user2["id"])
      end
    end
  end
end