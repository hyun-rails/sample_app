require 'spec_helper'

describe Micropost do

  let(:user) { FactoryGirl.create(:user) }
  before { @micropost = user.microposts.build(content: "Lorem ipsum") }
  

  subject { @micropost }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }

  # Below two functionalities are possible as a
  # result of user/micropost association. 
  it { should respond_to(:user) }
  its(:user) { should eq user }

  it { should be_valid }
  
  # Test for the validity of a new micropost
  describe "when user_id is not present" do
    before { @micropost.user_id = nil }
    it { should_not be_valid }
  end
  
  # Test for the Micropost model validation
  # Microposts with blank content shouldn't be valid.
  describe "with blank content" do
    before { @micropost.content = " " }
    it { should_not be_valid }
  end
  
  # Test for the Micropost model validation.
  # Microposts longer than 140 characters shouldn't be valid.
  describe "with content that is too long" do
    before { @micropost.content = "a" * 141 }
    it { should_not be_valid }
  end
end