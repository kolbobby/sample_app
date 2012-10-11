require 'spec_helper'

describe "StaticPages" do
  let(:base_title) { "Sample App" }
  
  describe "HomePage" do
    it "should have the correct title" do
      visit '/static_pages/home'
      page.should have_selector('title', :text => "#{base_title}")
    end
    it "should not have a custom page title" do
      visit '/static_pages/home'
      page.should_not have_selector('title', :text => " | Home")
    end
    it "should have the h1 content 'Sample App'" do
      visit '/static_pages/home'
      page.should have_selector('h1', :text => 'Sample App')
    end
  end
  
  describe "HelpPage" do
    it "should have the correct title" do
      visit '/static_pages/help'
      page.should have_selector('title', :text => "#{base_title} | Help")
    end
    it "should have the h1 content 'Help'" do
      visit '/static_pages/help'
      page.should have_selector('h1', :text => 'Help')
    end
  end
  
  describe "AboutPage" do
    it "should have the correct title" do
      visit '/static_pages/about'
      page.should have_selector('title', :text => "#{base_title} | About Us")
    end
    it "should have the h1 content 'About Us'" do
      visit '/static_pages/about'
      page.should have_selector('h1', :text => 'About Us')
    end
  end
end