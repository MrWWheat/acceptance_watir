require 'pages/community/admin'
require 'pages/community/home'
require 'pages/community/login'
require 'pages/community/layout'
require 'pages/community/profile'
require 'watir_config'
#require 'pages/base'

class Pages::Community::AdminOnBoarding < Pages::Community::Admin

  def initialize(config, options = {})
    super(config)
    
  end

  show_me_around_btn          { button(:text => "Show Me Around") }
  onboarding_container		    { div(:class => "onboarding-task-container") }
  setup_task				          { div(:class => "task-item", :text => /Setup/) }
  feature_mgr_task			      { div(:class => "task-item", :text => /Feature Management/) }
  content_mod_task			      { div(:class => "task-item", :text => /Content Moderation/) }
  integration_task			      { div(:class => "task-item", :text => /Integrations/) }
  branding_task				        { div(:class => "task-item", :text => /Branding/) }
  user_mgr_task				        { div(:class => "task-item", :text => /User Management/) }
  step_desc					          { span(:class => "step-desc") }

  def get_task task
  	case task
    when :setup
      setup_task
    when :feature_mgr
      feature_mgr_task
    when :content_mod
      content_mod_task
    when :integration
      integration_task
    when :branding
      branding_task
    when :user_mgr
      user_mgr_task
    else
      raise "#{@task} is not in the task list"
    end
  end

  def go_to_task task
  	task_icon = get_task task
  	task_icon.when_present.click
  end

  def task_is_actived task
  	task_icon = get_task task
  	task_icon.class_name.include? "active"
  end

  def task_is_completed task
  	task_icon = get_task task
  	task_icon.class_name.include? "completed"
  end

  def task_is_new task
  	!(task_is_actived task) && !(task_is_completed task)
  end

end
