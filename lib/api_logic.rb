require "api_logic/version"
require "api_logic/responder"

module ApiLogic
  extend ActiveSupport::Concern
  
  
  
  included do
    self.responder = ::ApiLogic::Responder
    
    guess_model
    
    def self.inherited(subclass)
      super
      subclass.guess_model
    end
  end
  
  
  
  module ClassMethods
    
    
    attr_reader :model_class
    alias :model :model_class
    attr_reader :model_collection
    attr_reader :model_singular
    
    
    def guess_model
      # puts "[api_logic] guessing model for #{self.name}"
      if self.name =~ /(?:.*::)(.*?)ApiController/
        model_name = $1.singularize
        begin
          exposes_model $1.singularize.constantize
        rescue NameError
          # puts "  there is no model \"#{model_name}\""
        end
      else
        # puts "  the controller does not match the pattern /(?:.*::)(.*?)ApiController/"
      end
    end
    
    
    def exposes_model(model_class)
      # puts "[api_logic] exposing model #{model_class} on #{self.name}"
      
      @model_class = model_class
      @model_collection = model_class.name.tableize
      @model_singular = @model_collection.singularize
      
      before_filter :find_model, :only => [:show, :update, :destroy]
      
    public
      
      define_method :index do
        collection = find_models
        instance_variable_set "@#{model_collection}", collection
        respond_with collection
      end
      
      define_method :show do
        respond_with @model
      end
      
      define_method :create do
        @model = create_model
        instance_variable_set "@#{model_singular}", @model
        respond_with @model
      end
      
      define_method :update do
        @model.update_attributes(update_attributes)
        respond_with @model
      end
      
      define_method :destroy do
        @model.destroy
        respond_with @model
      end
      
    end
    
  end
  
  
  
  def find_models
    model_class.all
  end
  
  def find_model
    @model = model_class.find(params[:id])
    instance_variable_set "@#{model_singular}", @model
  end
  
  def create_model
    model_class.create(create_attributes)
  end
  
  
  def create_attributes
    model_params
  end
  
  def update_attributes
    model_params
  end
  
  def model_params
    params[model_singular]
  end
  
  
  def model_class
    self.class.model
  end
  
  def model_collection
    self.class.model_collection
  end
  
  def model_singular
    self.class.model_singular
  end
  
  
  
end
