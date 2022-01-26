require 'rails_helper'

describe "interaction for AdminDashboard::InvoicesController", type: :feature do
  include HotGlue::ControllerHelper
  #HOTGLUE-SAVESTART
  #HOTGLUE-END
  
  
  let!(:invoice1) {create(:invoice, user: user , number: FFaker::Movie.title )}
    let(:user) {create(:user  )}
 

  describe "index" do
    it "should show me the list" do
      visit admin_dashboard_user_invoices_path
      expect(page).to have_content(invoice1.number)
    end
  end

  describe "new & create" do
    it "should create a new Invoice" do
      visit admin_dashboard_user_invoices_path
      click_link "New Invoice"
      expect(page).to have_selector(:xpath, './/h3[contains(., "New Invoice")]')


      click_button "Save"
      expect(page).to have_content("Successfully created")
      
    end
  end


  describe "edit & update" do
    it "should return an editable form" do
      visit admin_dashboard_user_invoices_path
      find("a.edit-invoice-button[href='/admin_dashboard/invoices/#{invoice1.id}/edit']").click

      expect(page).to have_content("Editing #{invoice1.number.squish || "(no name)"}")

      click_button "Save"
      within("turbo-frame#invoice__#{invoice1.id} ") do

      end
    end
  end 

  describe "destroy" do
    it "should destroy" do
      visit admin_dashboard_user_invoices_path
      accept_alert do
        find("form[action='/admin_dashboard/invoices/#{invoice1.id}'] > input.delete-invoice-button").click
      end
      expect(page).to_not have_content(invoice1.number)
      expect(Invoice.where(id: invoice1.id).count).to eq(0)
    end
  end
end

