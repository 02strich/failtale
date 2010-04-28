class Occurence < ActiveRecord::Base
  
  def self.per_page ; 20 ; end
  
  validates_presence_of :error
  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :properties
  validates_presence_of :reporter
  
  validate do |error|
    msg = "properties must be a hash with strings for keys and values."
    if error.properties
      if error.properties.is_a? Hash
        error.properties.each do |k,v|
          unless k.is_a?(String) and v.is_a?(String)
            error.errors.add(:properties, msg)
            break
          end
        end
      else
        error.errors.add(:properties, msg)
      end
    end
  end
  
  serialize(:properties)
  
  belongs_to :error, :counter_cache => true, :class_name => '::Error'
  
  default_scope :order => 'updated_at DESC'
  
  after_create do |r|
    r.error.update_attributes(:updated_at => DateTime.now)
    r.error.project.update_attributes(:updated_at => DateTime.now)
  end
  
  def first?
    self.error.occurences.count == 1
  end
  
end
