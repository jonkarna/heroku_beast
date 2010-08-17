namespace :heroku do
  task :bootstrap, [:site_name, :site_url] => ["db:schema:load", "db:migrate"] do |t, args|
    args.with_defaults(:site_name => "localhost", :site_url => "localhost")
    site = Site.new :name => args.site_name, :host => args.site_url
    site.save
    user = site.all_users.build :login => 'heroku', :email => 'admin@example.com'
    user.admin = true
    user.password = user.password_confirmation = 'heroku'
    user.save
    user.activate!
  end
end