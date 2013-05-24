Given /^a hitchhiker$/ do
  @user = FactoryGirl.create :user
end

Given /^a hitchhiker called "([^"]*)"$/ do |username|
  @user = FactoryGirl.create :user, username: username.downcase
end

Given /^a hitchhiker called "([^"]*)" from "([^"]*)"$/ do |username, city|
  user = FactoryGirl.create :user, username: username
  user.update_column :city, city
end

Given /^a hitchhiker from "([^"]*)"$/ do |city|
  FactoryGirl.create :user, city: city
end

Given /^his CS user is "([^"]*)"$/ do |cs_username|
  @user.cs_user = cs_username
  @user.save!
end

Given /^I am logged in$/ do
  @user = User.find_by_email('florian@hitchlog.com') || FactoryGirl.create(:user, email: "florian@hitchlog.com") unless @user
  visit new_user_session_path
  fill_in "Username", with: @user.username
  fill_in "Password", with: 'password'
  click_button "Hitch me up"
end

Given /^I am logged in as "([^"]*)"$/ do |username|
  @user = User.find_by_username(username) || FactoryGirl.create(:user, email: "#{username}@hitchlog.com", username: username) unless @user
  visit new_user_session_path
  fill_in "Username", with: @user.username
  fill_in "Password", with: 'password'
  click_button "Sign in"
end

Given /^I am logged in as "([^"]*)" from "([^"]*)"$/ do |username, city|
  user = FactoryGirl.create(:user, email: "#{username}@hitchlog.com", username: username)
  user.update_column :city, city

  visit new_user_session_path
  fill_in "Username", with: user.username
  fill_in "Password", with: 'password'
  click_button "Sign in"
end

Given /^I logged a trip$/ do
  @user.trips << FactoryGirl(:trip)
end

When /^I sign up as "([^"]*)"$/ do |arg1|
  fill_in "Username", :with => 'florian'
  fill_in "Email", :with => 'florian@hitchlog.com'
  fill_in "user_password", :with => 'password'
  fill_in "Password confirmation", :with => 'password'
  select  "male", :from => "Gender"
  click_button "Sign up"
end

Given /^(\d+) hitchhikers$/ do |number|
  number.to_i.times { FactoryGirl.create(:user) }
end

Then /^I should be able to see both hitchhikers$/ do
  User.all.each { |user| page.find("#user_#{user.id}").should have_content(user.to_s) }
end

When /^I change my location to "([^"]*)"$/ do |current_location|
  fill_in "Your current location", with: current_location
end

Then /^the current location of "([^"]*)" should be "([^"]*)"$/ do |username, arg2|
  pending # express the regexp above with the code you wish you had
end

When /^I visit the profile page of "([^"]*)"$/ do |username|
  visit user_path(username)
end
