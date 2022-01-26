require 'rails_helper'

describe "interaction for AdminDashboard::UsersController", type: :feature do
  include HotGlue::ControllerHelper
    #HOTGLUE-SAVESTART
  #HOTGLUE-END
  
  
  let!(:user1) {create(:user , email: FFaker::Internet.email, 
      name: FFaker::Movie.title )}
   

  describe "index" do
    it "should show me the list" do
      visit admin_dashboard_users_path
      expect(page).to have_content(user1.email)
      expect(page).to have_content(user1.name)
    end
  end

  describe "new & create" do
    it "should create a new User" do
      visit admin_dashboard_users_path
      click_link "New User"
      expect(page).to have_selector(:xpath, './/h3[contains(., "New User")]')

      new_email = 'new_test-email@nowhere.com' 
      find("[name='user[email]']").fill_in(with: new_email)
      new_name = 'new_test-email@nowhere.com' 
      find("[name='user[name]']").fill_in(with: new_name)
      click_button "Save"
      expect(page).to have_content("Successfully created")
      expect(page).to have_content(new_email)
      expect(page).to have_content(new_name)
    end
  end


  describe "edit & update" do
    it "should return an editable form" do
      visit admin_dashboard_users_path
      find("a.edit-user-button[href='/admin_dashboard/users/#{user1.id}/edit']").click

      expect(page).to have_content("Editing #{user1.name.squish || "(no name)"}")
      new_email = 'new_test-email@nowhere.com' 
      find("[name='user[email]']").fill_in(with: new_email)
      new_name = FFaker::Lorem.paragraphs(1).join 
      find("input[name='user[name]']").fill_in(with: new_name)
      click_button "Save"
      within("turbo-frame#user__#{user1.id} ") do
        expect(page).to have_content(new_email)
        expect(page).to have_content(new_name)
      end
    end
  end 

  describe "destroy" do
    it "should destroy" do
      visit admin_dashboard_users_path
      accept_alert do
        find("form[action='/admin_dashboard/users/#{user1.id}'] > input.delete-user-button").click
      end
      expect(page).to_not have_content(user1.name)
      expect(User.where(id: user1.id).count).to eq(0)
    end
  end
end

