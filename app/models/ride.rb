class Ride < ActiveRecord::Base  
  EXPERIENCES = ['very good',
                 'good',
                 'neutral',
                 'bad',
                 'very bad']

  VEHICLES =    ['car', 'bus', 'truck', 'motorcycle', 'plane', 'boat']

  validates_inclusion_of :experience, in: EXPERIENCES

  belongs_to :user
  belongs_to :trip
  has_one :person, :dependent => :destroy

  accepts_nested_attributes_for :person, :allow_destroy => true

  scope :with_photo, select{|r| r.photo.present?}
  scope :with_story, where("story <> ''")
  scope :latest_first, order('id DESC')
  scope :oldest_first, order('id ASC')

  scope :very_good_experiences, where(experience: "very good")
  scope :good_experiences,      where(experience: "good")
  scope :neutral_experiences,   where(experience: "neutral")
  scope :bad_experiences,       where(experience: "bad")
  scope :very_bad_experiences,  where(experience: "very bad")

  mount_uploader :photo, PhotoUploader

  acts_as_taggable_on :tags

  Ride::EXPERIENCES.each do |exp|
    define_singleton_method "#{exp.parameterize("_")}_experiences_ratio" do
      (( self.send("#{exp.parameterize("_")}_experiences").count.to_f / self.count ) * 100 ).round(2)
    end
  end

  def to_s
    self.trip
  end

  def to_param
    origin = CGI::escape(self.trip.sanitize_address('from'))
    destin = CGI::escape(self.trip.sanitize_address('to'))

    "#{id}-#{origin}-to-#{destin}".parameterize
  end

  def caption_or_title
    if photo_caption
      photo_caption
    elsif title
      title
    end
  end

  def markdown_story
    if not self.story.blank?
      RDiscount.new(self.story).to_html.html_safe 
    else
      ''
    end
  end
end
