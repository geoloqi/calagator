class Person < ActiveRecord::Base
  attr_accessible :name, :nickname, :email, :geoloqi_token, :twitter, :website, :photo_url

  has_paper_trail

  include VersionDiff

  xss_foliate :sanitize => [:name, :nickname, :email, :twitter, :website, :photo_url]
  include DecodeHtmlEntitiesHack

  # Triggers
  before_validation :normalize_website!

  # Validations
  validates_presence_of :name, :nickname
  validates_format_of :website,
    :with => /(http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/,
    :allow_blank => true,
    :allow_nil => true
  validates_format_of :photo_url,
    :with => /(http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/,
    :allow_blank => true,
    :allow_nil => true

  include ValidatesBlacklistOnMixin
  validates_blacklist_on :name, :nickname, :email, :geoloqi_token, :twitter, :website, :photo_url

  include UpdateUpdatedAtMixin

  # Duplicates
  include DuplicateChecking
  duplicate_checking_ignores_attributes    :person_id

  #===[ Triggers ]========================================================

  def normalize_website!
    unless self.website.blank? || self.website.match(/^[\d\D]+:\/\//)
      self.website = 'http://' + self.website
    end
  end

end
