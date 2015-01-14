# Seeding with FFaker also gives you the ability to
# => test the scalability of your application. (e.g change 100->1000)

# Creates 100 fake users
(1..100).each do
  user_params = Hash.new
  user_params[:email] = Faker::Internet.email
  user_params[:email_confirmation] = user_params[:email]
  user_params[:password]  = "blah"
  user_params[:password_confirmation] = user_params[:password]
  new_user = User.create(user_params)

  (1..10).each do
    new_article = Article.new
    new_article.title = Faker::HipsterIpsum.words(rand(8)+2).join(" ")
    new_article.content = Faker::HipsterIpsum.paragraphs(1+ rand(4)).join("\n")
    new_article.save
    new_user.articles.push new_article
  end
end