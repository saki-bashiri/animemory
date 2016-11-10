class UserMailer < ActionMailer::Base
  helper :application
  default :from => "saki@crewmo.com"
end
