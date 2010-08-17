namespace :app do
  task :app_specific => [:create_site] do
  end

  task :create_site => [:setup, :environment] do
    site = Site.new :name => 'localhost', :host => 'localhost'
    begin
      site.save!
    rescue ActiveRecord::RecordInvalid
      say "The site didn't validate for whatever reason. Fix and call site.save!"
      say site.errors.full_messages.to_sentence
      debugger
    end
    say "Site created successfully"
    say site.inspect
    puts
    user = site.all_users.build :login => 'admin', :email => 'admin@example.com'
    user.admin = true
    user.password = user.password_confirmation = 'admin'
    begin
      user.save!
    rescue ActiveRecord::RecordInvalid
      say "The user didn't validate for whatever reason. Fix and call user.save!"
      say user.errors.full_messages.to_sentence
      debugger
    end
    user.activate!
    say "User created successfully"
    say user.inspect
    puts
  end
  
end