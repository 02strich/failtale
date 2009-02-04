class Report
  
  include ::Validateable
  
  class ReportInvalid < Exception
    attr_accessor :record
    def initialize(record)
      @record = record
    end
  end
  
  def self.create!(params={})
    new(params).save!
  end
  
  attr_accessor :project, :error, :occurence
  
  validates_presence_of :project
  validates_presence_of :error
  validates_presence_of :occurence
  
  validates_associated :project
  validates_associated :error
  validates_associated :occurence
  
  def initialize(params={})
    self.project   = params['project']
    self.error     = params['error']
    self.occurence = params['occurence']
  end
  
  def save!
    unless valid?
      raise ActiveRecord::RecordInvalid.new(@project)   unless @project.nil?   or @project.valid?
      raise ActiveRecord::RecordInvalid.new(@error)     unless @error.nil?     or @error.valid?
      raise ActiveRecord::RecordInvalid.new(@occurence) unless @occurence.nil? or @occurence.valid?
      raise ReportInvalid.new(self)
    end
    @error.save!
    @occurence.save!
  rescue => e
    has_error = true
    raise e
  ensure
    @error.destroy if has_error and @error_was_created
  end
  
  def project=(object)
    if object.is_a? Hash
      object = object.slice('api_token')
      @project = Project.with_api_token(object['api_token']).first
    elsif object.is_a? Project
      @project = object
    else
      @project = nil
    end
  end
  
  def error=(object)
    if @project.nil?
      @error = nil
    elsif object.is_a? Hash
      object = object.slice('hash_string')
      @error   = @project.reports.with_hash(object['hash_string']).first
      @error ||= @project.reports.build(object)
      if @error.new_record?
        @error.save!
        @error_was_created = true
      end
      @error.updated_at = DateTime.now
    elsif object.is_a? Error
      @error = object
    else
      @error = nil
    end
  end
  
  def occurence=(object)
    if @error.nil?
      @occurence = nil
    elsif object.is_a? Hash
      object = object.slice('name', 'description', 'backtrace', 'properties')
      @occurence = @error.occurences.build(object)
    elsif object.is_a? Occurence
      @occurence = object
    else
      @occurence = nil
    end
  end
  
end