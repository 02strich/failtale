class ErrorsController < ApplicationController
  
  helper_method :errors, :error, :project
  
  before_filter :require_user
  before_filter :require_membership
  
  def index
    errors
    respond_to do |format|
      format.html { redirect_to project }
      format.xml  { render :xml  => errors }
      format.json { render :json => errors }
    end
  end
  
  def show
    error
    respond_to do |format|
      format.html # render show.html.erb
      format.xml  { render :xml  => error }
      format.json { render :json => error }
    end
  end
  
  private
  
  def project
    @project ||= current_user.projects.find(params[:project_id])
  end
  
  def errors
    @errors ||= project.reports.all
  end
  
  def error
    @error ||= project.reports.find(params[:id])
  end
  
end
