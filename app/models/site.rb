class Site
  def self.domain
    Rails.env == 'production' ? 'http://cohuman-registrar.heroku.com' : 'http://localhost:5000'
  end
end