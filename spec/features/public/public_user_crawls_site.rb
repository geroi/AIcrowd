require 'rails_helper'

feature "site navigation for authenticated participant" do
  let!(:participant) { create(:participant) }
  3.times do |i|
    let!("challenge_#{i + 1}") { create :challenge, :running }
  end
  let(:draft) { create :challenge, :draft }
  3.times do |i|
    let!("article_#{i + 1}") { create :article, :with_sections }
  end

  context "landing page" do
    scenario do
      visit_landing_page
      expect(page).to have_content challenge_1.challenge
      # expect(page).to have_link 'Knowledge Base'
      expect(page).to have_link 'Challenges'
      expect(page).to have_link 'Sign up'
      expect(page).to have_link 'Log in'
      expect(page).not_to have_link 'Admin'
    end
  end

  context "challenges" do
    scenario do
      visit_landing_page
      visit_challenges
      expect(page).to have_content challenge_1.challenge
      expect(page).to have_content challenge_2.challenge
      expect(page).to have_content challenge_3.challenge
      expect(page).not_to have_content draft.challenge
    end
  end

  context 'challenge page' do
    scenario do
      visit_challenge(challenge_1)
      expect(page).to have_link 'Overview'
      expect(page).to have_link 'Leaderboard'
      expect(page).to have_link 'Discussion'
      expect(page).to have_link 'Dataset'
      expect(page).to have_link 'FOLLOW'
      # TODO - look for edit icon ... expect(page).not_to have_link 'Edit'
    end
  end

  context "challenge tabs", js: true do
    scenario do
      visit_challenge(challenge_1)
      click_link "Overview"
      expect(page).to have_link 'Overview',
        class: 'active'
      click_link "Leaderboard"
      expect(page).to have_link 'Leaderboard',
        class: 'active'
      click_link "Discussion"
      expect(page).to have_link 'Discussion',
        class: 'active'
      click_link "Dataset"
      expect(page).to have_text 'You need to sign in or sign up before continuing'
    end
  end

  context 'organizer' do
    scenario do
      visit_challenge(challenge_1)
      click_link challenge_1.organizer.organizer
      expect(page).to have_text(challenge_1.organizer.organizer)
      expect(page).to have_link 'Challenges'
      expect(page).not_to have_text 'Members'
    end
  end

  # context 'knowledge base' do
  #   scenario do
  #     visit_knowledge_base
  #     expect(page).to have_content article_1.article
  #     expect(page).to have_content article_2.article
  #     expect(page).to have_content article_3.article
  #   end
  # end

  context 'article' do
    scenario do
      visit_article(article_1)
      expect(page).to have_content article_1.article
    end
  end

  context 'participant profile' do
    scenario 'access profile via article', js: true do
      visit_article(article_1)
      click_link article_1.participant.name
      expect(page).to have_css('h2', text: article_1.participant.name)
      within 'div.sub-nav' do
        expect(page).to have_link 'Challenges'
      end
    end
  end

end
