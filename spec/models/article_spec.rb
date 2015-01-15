require 'rails_helper'

RSpec.describe Article, :type => :model do

	before(:each) do
		@user = User.create({
  												email: "blah@blah.com", 
  												email_confirmation: "blah@blah.com",
  			 									password: "blah", 
  			 									password_confirmation: "blah"
  			 									})
  	@article = @user.articles.create({title: "foo", content: "bar"})
  end

  describe "author getter" do
  	
  	it "should return the associated user.email" do 
  		expect(@article.author).to eq(@user.email)
  	end
  end
end
