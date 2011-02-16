class Invitation < ActiveRecord::Base
  belongs_to :inviter, :class_name => 'User'
  
  before_create :post_invite
  
  def post(url, params)
    inviter.access_token.post(url, params)
  end
  
  def cohuman_domain
    OAUTH_CREDENTIALS[:cohuman][:options][:site]
  end
  
  GENERAL_ERROR = "We are sorry. Something went wrong"
  
  def post_invite
    response = post("#{cohuman_domain}/invitation", :addresses => self.email, :format => 'json')
    if response.respond_to?(:body)
      hash = JSON.parse(response.body)
      invitee = hash['activity'] && hash['activity']['invitees'] && hash['activity']['invitees'].first
      invitee = hash['activity'] && hash['activity']['existing_users'] && hash['activity']['existing_users'].first unless invitee
      if invitee
        self.invitee_id = invitee['id'] 
        post_tasks
      else
        error = hash["error"] && hash["error"]["message"]
        raise error || GENERAL_ERROR
      end
    else
      raise GENERAL_ERROR
    end
  end
  
  def post_tasks
    response = post("#{cohuman_domain}/task", :owner_id => invitee_id, :format => 'json', :name => generate_names) rescue nil
  end
  
  def generate_names
    length = TASK_NAMES.size
    names = ""
    [rand(length), rand(length), rand(length)].each_with_index do |num, index|
      names << "#{TASK_NAMES[num]}"
      names << "; " unless index == 2
    end
    names
  end
  
  def get_tasks
    response = inviter.access_token.get("#{cohuman_domain}/user/#{invitee_id}", {"Content-Type" => "application/json"})
    array = []
    if response.respond_to?(:body)
      hash = JSON.parse(response.body)
      if task_array = hash['user'] && hash['user']['just_added_tasks']
        task_array.each do |task_hash|
          array << task_hash['name']
        end
      end
    end
    array
  end
  
  TASK_NAMES = [
    "Call my parents",
    "Do my taxes",
    "Plan a vacation",
    "Take out the trash",
    "Ask for a raise",
    "Ask for a new computer",
    "Update my resume",
    "Research raising chickens",
    "Start planning for Zombie apocalypse",
    "Fwd this to a Cohuman to become Pro 4 Free ",
    "Check out Cohuman API",
    "Create an app using Cohuman API",
    "Submit my SXSW expenses",
    "Pick a language to learn this year",
    "Hire an assistant",
    "Get passport photos shot",
    "Schedule office party",
    "Surprise Schnookums with a random gift",
    "Beat my boss to work next Tuesday",
    "Tidy up my desk",
    "Buy 'that guy' at work some deodorant",
    "Showoff Cohuman at the next company meeting",
    "Buy a new laptop bag",
    "Put money aside for iPhone5",
    "Remember Mother's day - May 8",
    "Tidy bedroom before date shows",
    "Cancel gym membership",
    "Re supply stockpile of twinkies & Doctor Pepper",
    "Test-test-test",
    "Buy another iPad... & a kindle",
    "Cancel gym membership",
    "Unsubscribe from mail order bride site",
    "Schedule doctor visit",
    "Find new dentist that has good breath",
    "Pay parking ticket",
    "Pay less taxes",
    "Update gravatar picture",
    "De-friend ex-girlfriend",
    "Change cell phone providers",
    "Repair bicycle",
    "Book travel to comic-con 7/21-24",
    "Remember Father's day June 19",
    "Friend Cohuman on Facebook",
    "Follow Cohuman on Twitter",
    "Subscribe to Cohuman Blog",
    "CLEAN TOILET -- before date",
    "Buy more TP and beer tonight",
    "Buy batteries for TV remote",
    "'Borrow' printer paper from work",
    "Buy a new toothbrush",
    "Record Game of Thrones premier April 17th 2011",
    "Schedule Poker night",
    "Get commitments from gang for college reunion",
    "Tell team I'm 'working from home' next Friday",
    "Buy lots of flowers",
    "Get a subscription to the New Yorker",
    "Tweet how awesome Cohuman is",
    "Replace office chair with one that doesn't smell",
    "Write my will"
  ].map(&:strip)
end
