class Site < ActiveRecord::Base
  class UndefinedError < StandardError; end

  has_many :users, :conditions => {:state => 'active'}
  has_many :all_users, :class_name => 'User'
  
  has_many :forums
  has_many :topics, :through => :forums
  
  validates_presence_of   :name
  validates_uniqueness_of :host
  
  def host=(value)
    write_attribute :host, value.to_s.downcase
  end
  
  def self.main
    @main ||= find :first, :conditions => {:host => ''}
  end
  
  def self.find_by_host(name)
    return nil if name.nil?
    name.downcase!
    name.strip!
    name.sub! /^www\./, ''
    sites = find :all, :conditions => ['host = ? or host = ?', name, '']
    sites.reject { |s| s.default? }.first || sites.first
  end
  
  # <3 rspec
  def ordered_forums(*args)
    forums.find_ordered(*args)
  end
  
  def default?
    host.blank?
  end
end