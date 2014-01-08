require 'spec_helper'

describe "AuthenticationPages" do
  
  subject { page }

  describe "signin page" do
  	before { visit signin_path }

  	it { should have_content('Sign in')}
  	it { should have_title('Sign in')}
  end

  describe "signin" do
	before { visit signin_path }

	describe "with invalid information" do
	  before { click_button "Sign in" }

	  it { should have_title('Sign in') }
	  it { should have_selector('div.alert.alert-error') }

    describe "after visiting another page" do
      before { click_link "Home" }
      it { should_not have_selector('div.alert.alert-error') }
    end
	end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user } # See spec/support/utilities.rb for sign_in implementation

      it { should have_title(user.name) }
      it { should have_link('Users',       href: users_path)}
      it { should have_link('Profile',     href: user_path(user)) }
      it { should have_link('Sign out',    href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }
      it { should have_link('Settings',    href: edit_user_path(user))}

      describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
      end
    end
  end

  
  
  # Tests behavior of signed and non-signed users
  describe "authorization" do
    
    # Signed-in users have no reason to access the new and
    # create actions in the Users controller. Signed-in
    # users will be redirected to the root URL if they do
    # try to hit those pages.
    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }
      
      # I don't think these tests do what they're supposed to do
      it { should_not have_title('Sign up')}
      it { should_not have_title('Sign in')}
    end

    # Testing that the edit and update actions are protected from
    # unsigned users. These tests verify that non-signed-in users
    # attempting to access are sent to the signin page.
    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      # Linkes to "Profile" and "Settings" should not appear when
      # a user isn't signed in
      it { should_not have_link('Settings',  href: edit_user_path(user))}
      it { should_not have_link('Profile',   href: user_path(user))}

      describe "in the Users controller" do

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_title('Sign in') }
        end
        
        # The user index should be restricted to 
        # signed-in users only
        describe "visiting the user index" do
          before { visit users_path }
          it { should have_title('Sign in') }
        end

        describe "submitting to the update action" do
          before { patch user_path(user) }
          # "respose" is a low-level object that represent the
          # server response. In this case we want the action to
          # redirect to the signin page
          specify { expect(response).to redirect_to(signin_path) }
        end
      end

      # Access control tests for microposts
      describe "in the Microposts controller" do

        describe "submitting to the create action" do
          before { post microposts_path } # "create" action
          specify { expect(response).to redirect_to(signin_path) }
        end

        describe "submitting to the destroy action" do
          before { delete micropost_path(FactoryGirl.create(:micropost)) } # "destroy" action"
          specify { expect(response).to redirect_to(signin_path) }
        end
      end

      
      # Tests friendly forwarding. Friendly forwarding directs
      # non-logged-in users to their initially intended pages 
      # once they log-in
      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email",    with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end

        describe "after signing in" do

          it "should render the desired protected page" do
            expect(page).to have_title('Edit user')
          end
          
          # Friendly forwarding should only forward to the given
          # URL the first time. On subsequent signin attempts, the
          # forwarding URL should revert to the default
          describe "when signing in again" do
            before do
              delete signout_path
              visit signin_path
              fill_in "Email",    with: user.email
              fill_in "Password", with: user.password
              click_button "Sign in"
            end

            it "should render the default (profile) page" do
              expect(page).to have_title(user.name)
            end
          end
        end
      end

    end
    

    # User should only be allowed to edit their own information. 
    # These tests varify that users can only edit their own info. 
    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user, no_capybara: true }

      describe "submitting a GET request to the Users#edit action" do
        before { get edit_user_path(wrong_user) }
        specify { expect(response.body).not_to match(full_title('Edit user')) }
        specify { expect(response).to redirect_to(root_url) }
      end

      describe "submitting a PATCH request to the Users#update action" do
        before { patch user_path(wrong_user) }
        specify { expect(response).to redirect_to(root_url) }
      end
    end
    
    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin, no_capybara: true }
      
      # Non-admin users can't delete users by issuing DELETE request
      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) } # Issue a DELETE request directly to the specified URL
        specify { expect(response).to redirect_to(root_url) }
      end
    end

  end
end
