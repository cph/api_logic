require "api_logic/version"
require "api_logic/responder"

module ApiLogic
  extend ActiveSupport::Concern



  included do
    self.responder = ::ApiLogic::Responder

    before_filter :find_model, :only => [:show, :update, :destroy]

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
      return unless self.name =~ /(?:.*::)(.*?)ApiController/
      model_name = $1.singularize
      return if model_name.blank?

      exposes_model model_name.constantize
    rescue NameError
      Rails.logger.debug "[api_logic] there is no model named \"#{model_name}\""
    end


    def exposes_model(model_class)
      @model_class = model_class
      @model_collection = model_class && model_class.name.tableize
      @model_singular = model_collection && model_collection.singularize
    end

  end



  def index
    raise NotImplementedError unless model_class

    collection = find_models
    instance_variable_set "@#{model_collection}", collection
    respond_with collection
  end

  def show
    raise NotImplementedError unless model_class

    respond_with @model
  end

  def create
    raise NotImplementedError unless model_class

    @model = create_model
    instance_variable_set "@#{model_singular}", @model
    respond_with @model
  end

  def update
    raise NotImplementedError unless model_class

    @model.update_attributes(update_attributes)
    respond_with @model
  end

  def destroy
    raise NotImplementedError unless model_class

    @model.destroy
    respond_with @model
  end



protected

  def find_models
    model_class.all
  end

  def find_model
    return unless model_class
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
