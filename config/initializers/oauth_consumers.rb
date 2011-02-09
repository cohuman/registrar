# edit this file to contain credentials for the OAuth services you support.
# each entry needs a corresponding token model.
#
# eg. :twitter => TwitterToken, :hour_feed => HourFeedToken etc.
#
# OAUTH_CREDENTIALS={
#   :twitter=>{
#     :key=>"",
#     :secret=>"",
#     :allow_login => true # Use :allow_login => true to allow user to login to account
#   },
#   :google=>{
#     :key=>"",
#     :secret=>"",
#     :scope=>"" # see http://code.google.com/apis/gdata/faq.html#AuthScopes
#   },
#   :agree2=>{
#     :key=>"",
#     :secret=>""
#   },
#   :fireeagle=>{
#     :key=>"",
#     :secret=>""
#   },
#   :hour_feed=>{
#     :key=>"",
#     :secret=>"",
#     :options=>{ # OAuth::Consumer options
#       :site=>"http://hourfeed.com" # Remember to add a site for a generic OAuth site
#     }
#   },
#   :nu_bux=>{
#     :key=>"",
#     :secret=>"",
#     :super_class=>"OpenTransactToken",  # if a OAuth service follows a particular standard 
#                                         # with a token implementation you can set the superclass
#                                         # to use
#     :options=>{ # OAuth::Consumer options
#       :site=>"http://nubux.heroku.com" 
#     }
#   }
# }
# 
unless defined? OAUTH_CREDENTIALS
  options = if ENV['COHUMAN_API_KEY']
    HashWithIndifferentAccess.new({
        :key => ENV['COHUMAN_API_KEY'],
        :secret => ENV['COHUMAN_API_SECRET']
    })
  else
    HashWithIndifferentAccess.new(YAML.load( File.read( "#{Rails.root}/config/cohuman.yml") )[Rails.env])
  end
  options.merge!(
    :options => {
      :site => 'http://api.cohuman.com',
      :request_token_path => '/api/token/request',
      :authorize_path => '/api/authorize',
      :access_token_path => '/api/token/access'
    }
  )
  
  OAUTH_CREDENTIALS = {:cohuman => options }
end

load 'oauth/models/consumers/service_loader.rb'