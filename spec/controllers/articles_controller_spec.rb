require 'rails_helper'

# rails generate rspec:install created this line
RSpec.describe ArticlesController, :type => :controller do
  ## *Setup step* 
  # => before runs once, and then moves on through the test
  before do
    user_params = Hash.new
    user_params[:email] = Faker::Internet.email
    user_params[:email_confirmation] = user_params[:email]
    user_params[:password]  = "blah"
    user_params[:password_confirmation] = user_params[:password]
   
    # => @current_user is an instance var, we can use it in any of the test below.
    # => we make variables we want to use in our it blocks instance variables
    @current_user = User.create(user_params)

    # "Stubbing"
    # => We use stubs for things we don't care about... right now
    # => * Copy and Paste this into other rspec controller tests *
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@current_user)
    allow_any_instance_of(Article).to receive(:get_keywords).and_return([])
  end

  # This test will pass as long as you have  
  # => def index ... end in articles_controller
  describe "Get #index" do
    it "should render the :index view" do 
      get :index
      expect(response).to render_template(:index)
    end

    it "should assign @articles" do
     all_articles = Article.all
     get :index
     # assigns only works for instance variables
     # => this checks your index method for @articles being assigned to Article.all
     expect(assigns(:articles)).to eq(all_articles)
    end
  end
  
  describe "Get #new" do
    it "should assign @article" do
      get :new
      expect(assigns(:article)).to be_instance_of(Article)
    end

    it "should render the :new view" do
      # Exercising (phase 2)
      get :new
      # Verifying (phase 3) expecting 'new' method in controller to render template
      expect(response).to render_template(:new)
    end 
  end
  
  describe "Get #create" do
    it "should redirect_to 'article_path' after successful create" do
      post :create, article: {title: "blah", content: "blah"}
      # look up how to test a redirect_to
      # that is what we are doing here
      expect(response.status).to be(302)
      expect(response.location).to match(/\/articles\/\d+/)
    end

    it "should add article to current_user" do
      # gets all articles in db associated w/ @current_user
      starting_count = @current_user.articles.all.count
      # we're posting to articles#create w/ params => {article: ... }
      post :create, article: {title: "blah", content: "blah"}
      # checks to see if the new article.count is > starting count
      expect(@current_user.articles.count).to be > starting_count
    end

    it "should redirect when create fails" do
      # faking the controller out.  we fake the failure, and return false.
      allow(@current_user.articles).to receive(:create).and_return(false)
      post :create, article: { title: "blah", content: "blah"}
      # then redirect to new_article_path
      expect(response).to redirect_to(new_article_path)
    end
  end
end
