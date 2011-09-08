require 'action_controller/metal/responder'

module ApiLogic
  class Responder < ActionController::Responder
    
    
    def respond
      
      # api_behavior checks for errors in Rails 3.0.3, but not in Rails
      # 3.1.0. To be sure that we behave correctly, check here.
      if has_errors? && !get?
        controller.render format => resource.errors, :status => :unprocessable_entity
        
      else
        
        # An API controller might want to tailor its response
        # with a RABL template. If a template exists, render that.
        #
        # Also, if the resource is nil or if it doesn't respond to
        # :to_#{format}, fall back to the default render functionality.
        #
        template_path = File.join(controller.controller_path, controller.action_name)
        if resource.nil? || !resourceful? || controller.template_exists?(template_path)
          render
        else
          
          # api_behavior takes as a parameter the error it will throw if
          # the resource does not respond to :to_#{format}. (Since we've
          # already checked :resourceful?, this error should never be thrown,
          # but just in case, we'll supply NotImplementedError.)
          api_behavior(NotImplementedError)
        end
      end
    end
    
    
  end
end

# Refer to the source of ActionController::Responder:
# https://github.com/rails/rails/blob/v3.0.3/actionpack/lib/action_controller/metal/responder.rb#L155
# https://github.com/rails/rails/blob/v3.1.0/actionpack/lib/action_controller/metal/responder.rb#L198
