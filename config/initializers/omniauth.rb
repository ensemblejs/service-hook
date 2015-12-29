Rails.application.config.middleware.use OmniAuth::Builder do
  # provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET'], scope: "user:email,user:follow"
  provider :github, 'cf5143f8051698921c8b', '4ec49340b46b788835f8c1991c6884320146f61c', scope: "user:email,repo"
end