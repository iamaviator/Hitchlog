class Trip < ActiveRecord::Base
  has_many :rides, :dependent => :destroy
  has_many :country_distances, :dependent => :destroy
  belongs_to :user

  default_scope :order => 'start DESC'
  
  validates :from, :presence => true
  validates :to, :presence => true
  validates :distance, :numericality => true
  validates :user_id, :presence => true
  validates :hitchhikes, :presence => true, :if => :new_record
  
  concerned_with :googlemaps, :countries

  cattr_reader :per_page
  @@per_page = 20

  attr_accessor :hitchhikes, :start_time, :end_time

  accepts_nested_attributes_for :rides

  before_save do
    # build as much rides on top of the ride as needed
    hitchhikes.to_i.times{|i| rides.build(:number => i+1) }
  end

  def to_s
    "#{from_city_sanitized} &rarr; #{to_city_sanitized}".html_safe
  end

  def to_param
    from_param = from.gsub(/[^[:alnum:]]/,'-').gsub(/-{2,}/,'-')
    to_param   = to.gsub(/[^[:alnum:]]/,'-').gsub(/-{2,}/,'-')
    "#{id}-#{from_param}->#{to_param}"
  end
  
  def to_date
    start.nil? ? '' : start.strftime("%d %B %Y")    
  end

  def to_city_sanitized
    self.to_city.blank? ? self.to_country : self.to_city
  end

  def from_city_sanitized
    self.from_city.blank? ? self.from_country : self.from_city
  end

  def new_duration
    if !self.duration.nil?
      self.duration
    elsif !self.start.nil? && self.end.nil?
      (self.end - self.start)/60/60
    else
      nil
    end
  end

  def new_record
    new_record?
  end
end
