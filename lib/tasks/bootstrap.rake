namespace :heroku do
  task :bootstrap, [:site_name, :site_url] => ["db:schema:load", "db:migrate"] do |t, args|
    args.with_defaults(:site_name => "localhost", :site_url => "localhost")
    site = Site.new :name => args.site_name, :host => args.site_url
    puts "1"
    site.save!
    puts "2"
    user = site.all_users.build :login => 'heroku', :email => 'admin@example.com'
    puts "3"
    user.admin = true
    puts "4"
    user.password = user.password_confirmation = 'heroku'
    puts "5"
    user.save!
    puts "6"
    user.activate!
  end
end