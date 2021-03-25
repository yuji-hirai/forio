require 'rails_helper'

RSpec.describe "Home", type: :request do
  describe "GET #TOP" do
    before { get root_path }

    it "TOPページ画面の表示に成功すること" do
      expect(response).to have_http_status(200)
    end
    it 'タイトルが正しく表示されているか' do
      expect(response.body).to include "Tidy"
    end
  end
end
