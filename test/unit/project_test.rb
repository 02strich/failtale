require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  
  should_require_attributes :name
  should_require_attributes :owner_id
  
  should_have_many :memberships, :dependent => :destroy
  should_have_many :members, :through => :memberships
  should_have_many :reports, :dependent => :destroy
  
  should_belong_to :owner
  
  context "with other projects" do
    setup do
      Factory(:project)
    end

    should_require_unique_attributes :api_token
    should_require_unique_attributes :name, :scoped_to => :owner_id
  end
  
  should "create membership for owner" do
    @user = Factory(:user)
    @project = Factory(:project, :owner => @user)
    assert ! @project.memberships.find(:first, :conditions => { :user_id => @user.id }).nil?
  end
  
end
