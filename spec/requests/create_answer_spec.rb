require 'spec_helper'

describe "Answers", js: true do
  let(:user) {FactoryGirl.create(:user)}
  subject {page}

  before do
    @lo = FactoryGirl.create(:lo, :with_introductions_and_exercises)
    @team = FactoryGirl.create(:team)
    @team.los.push @lo
    @team.enroll(user, @team.code)
  end

  describe "visit exercise one page and answer question one" do
    before do
      login user
      visit "/published/teams/#{@team.id}/los/#{@lo.id}/pages/4"
      first("div.span3.answer").click
    end

    it "should give correct answer" do
      find("input.keyboard-input").set("x + 1")
      first("a.send").click
      wait_for_ajax
      should have_css("div.span3.answer .right-answer")
    end

    it "should give wrong answer" do
      find("input.keyboard-input").set("x + 1")
      first("a.send").click
      wait_for_ajax
      should have_css("div.span3.answer .right-answer")
    end
  end
end
