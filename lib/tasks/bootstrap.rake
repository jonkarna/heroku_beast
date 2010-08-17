namespace :heroku do
  task :bootstrap, [:site_name, :site_url] => ["db:schema:load", "db:migrate"] do |t, args|
    args.with_defaults(:site_name => "localhost", :site_url => "localhost")
    site = Site.new :name => args.site_name, :host => args.site_url
    puts '1'
    if site.save!
      puts '2'
      user = site.all_users.build :login => 'heroku', :email => 'admin@example.com', :admin => true
      puts '3'
      user.password = user.password_confirmation = 'heroku'
      puts '4'
      begin
        user.save!
      rescue ActiveRecord::RecordInvalid
        puts user.errors.full_messages.to_sentence
        debugger
      end
      puts '5'
      user.activate!
    end
  end
  task :create_user, [:site_url] => [:environment] do |t, args|
    args.with_defaults(:site_url => "localhost")
    site = Site.find_by_host args.site_url
    unless site.nil?
      user = site.all_users.build :login => 'heroku', :email => 'admin@example.com', :admin => true
      user.password = user.password_confirmation = 'heroku'
      begin
        user.save!
      rescue
        puts user.errors.full_messages.to_sentence
        debugger
      end
      user.activate!
    end
  end
end