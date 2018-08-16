require 'action_controller/responder'

module ApiLogic
  class Responder < ActionController::Responder


    def respond

      # api_behavior checks for errors in Rails 3.0.3, but not in Rails
      # 3.1.0. To be sure that we behave correctly, check here.
      if has_errors? && !get?
        controller.render format => {:errors => resource.errors}, :status => :unprocessable_entity

      else

        # An API controller might want to tailor its response
        # with a RABL template. If a template exists, render that.
        #
        # Also, if the resource is nil or if it doesn't respond to
        # :to_#{format}, fall back to the default render functionality.
        #
        template_path = File.join(controller.controller_path, controller.action_name)
        if resource.nil? || !has_renderer? || controller.template_exists?(template_path)
          render
        else
          api_behavior
        end
      end
    end


    def display(resource, given_options={})
      super resource, given_options.merge(:callback => controller.params[:callback])
    end


  end
end

# Refer to the source of ActionController::Responder:
# https://github.com/rails/rails/blob/v3.0.3/actionpack/lib/action_controller/metal/responder.rb#L155
# https://github.com/rails/rails/blob/v3.1.0/actionpack/lib/action_controller/metal/responder.rb#L198
