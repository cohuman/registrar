def random8
  (0...8).collect{ ('a'..'z').to_a[rand(26)] }.join
end

Factory.define :user do |f|
  f.password  'password'
  f.password_confirmation 'password'
  f.email {"#{random8}@example.com".downcase }
end

Factory.define :access_token do |f|
  f.token random8
  f.secret random8
end