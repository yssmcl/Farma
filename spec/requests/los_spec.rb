require 'spec_helper'

describe "Los", :js => true do
  let(:user) {FactoryGirl.create(:user)}
  subject {page}
  before do
    sign_in user
  end
  
  describe "Los index", focus: true do
    before { click_link "los-link" }

    it { should have_content('Objetos de Aprendizagem') }
  end
end
