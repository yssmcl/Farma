require 'spec_helper'

describe "Los" do
  let(:user) {FactoryGirl.create(:user)}
  subject {page}

  before do
    login user
  end

  describe "Dashboard", :js => true do
    before { visit '/dashboard' }

    it { should have_link('Objetos de Aprendizagem') }
    it { should have_link('Meus Objetos de Aprendizagem') }
  end

  describe "Shared Los index", :js => true do
    before do
      @los = [FactoryGirl.create(:lo), FactoryGirl.create(:lo), FactoryGirl.create(:lo)]
      visit '/shared-los'
    end
    it { should have_content('Objetos de Aprendizagem compartilhados') }
    it "should see available los" do
      @los.each do |lo|
        have_content(lo.name)
        have_content(lo.description)
        have_link('Visualizar')
      end
    end
  end

  describe "create lo", :js => true do
    before { visit '/my-los/new' }
    let(:lo) { FactoryGirl.build(:lo) }

    before do
      fill_in "name",  with: lo.name
      fill_in "description", with: lo.description
      check('available')
      click_button "Salvar"
    end

    it { should have_selector('div.alert.alert-success') }
  end
end
