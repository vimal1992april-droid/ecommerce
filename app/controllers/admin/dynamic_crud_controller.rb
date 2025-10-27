# app/controllers/admin/dynamic_crud_controller.rb
class Admin::DynamicCrudController < ApplicationController
  require 'csv'
  
  layout "admin"
  before_action :set_model
  before_action :set_resource, only: [:edit, :update, :destroy]

  # GET /admin/:model
  def index
    @model = model_class(params[:model])

    # --- Filtering ---
    @query = params[:query]
    if @query.present?
      searchable_columns = @model.column_names - (@model.respond_to?(:hidden_columns) ? @model.hidden_columns : [])
      like_conditions = searchable_columns.map { |col| "#{col} LIKE :search" }.join(" OR ")
      @resources = @model.where(like_conditions, search: "%#{@query}%")
    else
      @resources = @model.all
    end

    # --- Column pagination setup ---
    all_columns = @model.column_names - (@model.respond_to?(:hidden_columns) ? @model.hidden_columns : [])
    per_page = 5
    @col_page = (params[:col_page] || 1).to_i
    start_index = (@col_page - 1) * per_page
    @visible_columns = all_columns[start_index, per_page] || []

    @has_prev_col = @col_page > 1
    @has_next_col = start_index + per_page < all_columns.size

    # --- Row pagination setup ---
    row_per_page = 20
    @page = (params[:page] || 1).to_i
    @total_pages = (@resources.count / row_per_page.to_f).ceil
    @resources = @resources.offset((@page - 1) * row_per_page).limit(row_per_page)
  end



  # GET /admin/:model/new
  def new
    #render json: @model.new
    @model_class = params[:model].classify.safe_constantize
    @resource = @model.new
  end

  def create
    @model_class = params[:model].classify.safe_constantize
    @resource = @model_class.new(resource_params)

    if @resource.save
      redirect_to admin_dynamic_crud_index_path(model: params[:model]), notice: "#{params[:model].titleize} created successfully."
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
    @model = model_class(params[:model])
    records = @model.all

    # Exclude hidden columns if defined
    columns = @model.column_names - (@model.respond_to?(:hidden_columns) ? @model.hidden_columns : [])

    csv_data = CSV.generate(headers: true) do |csv|
      csv << columns

      records.each do |record|
        csv << columns.map { |col| record.send(col) }
      end
    end

    filename = "#{@model.name.underscore}_export_#{Time.now.strftime('%Y%m%d_%H%M%S')}.csv"
    send_data csv_data, filename: filename, type: 'text/csv'
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
    # Permit all column names dynamically
    @model_class = params[:model].classify.safe_constantize
    params.require(@model_class.model_name.param_key).permit(@model_class.column_names.map(&:to_sym))
  end

  private

  def model_class(name)
    name.classify.constantize
  end
end
