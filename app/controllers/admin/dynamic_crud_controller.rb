# app/controllers/admin/dynamic_crud_controller.rb
class Admin::DynamicCrudController < ApplicationController
  layout "admin"
  before_action :set_model
  before_action :set_resource, only: [:edit, :update, :destroy]

  # GET /admin/:model
  def index
    @resources = @model.all
  end

  # GET /admin/:model/new
  def new
    #render json: @model.new
    @model_class = params[:model].classify.safe_constantize
    @resource = @model.new
  end

  def create
    @resource = @model.new(resource_params)
    if @resource.save
      redirect_to admin_dynamic_crud_index_path(model: params[:model]), notice: "#{@model} created successfully."
    else
      render :new
    end
  end

  def edit; end

  def update
    if @resource.update(resource_params)
      redirect_to admin_dynamic_crud_index_path(model: params[:model]), notice: "#{@model} updated successfully."
    else
      render :edit
    end
  end

  def destroy
    @resource.destroy
    redirect_to admin_dynamic_crud_index_path(model: params[:model]), notice: "#{@model} deleted successfully."
  end

  def import
    # dynamic import logic
  end

  def export
    # dynamic export logic
  end

  private

  def set_model
    @model = params[:model].classify.constantize
  rescue NameError
    redirect_to root_path, alert: "Model not found"
  end

  def set_resource
    @resource = @model.find(params[:id])
  end

  def resource_params
    params.require(@model.model_name.param_key)
          .permit(@model.column_names.map(&:to_sym))
  end
end
