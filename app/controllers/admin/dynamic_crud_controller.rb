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

  def edit
    @model_class = params[:model].classify.constantize
    @resource = @model_class.find(params[:id])
  end

  def update
    @model_class = params[:model].classify.constantize
    @resource = @model_class.find(params[:id])

    if @resource.update(permitted_params)
      redirect_to admin_dynamic_crud_index_path(model: params[:model]), notice: "#{@model} updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @resource.destroy
    redirect_to admin_dynamic_crud_index_path(model: params[:model]), notice: "#{@model} deleted successfully."
  end

  def sample_csv
    require "csv"

    model_class = params[:model].classify.constantize
    attributes = model_class.column_names - ["id", "created_at", "updated_at"]

    csv_data = CSV.generate(headers: true) do |csv|
      # Add header row
      csv << attributes

      # Add up to 5 existing records if available
      if model_class.exists?
        model_class.limit(5).each do |record|
          csv << attributes.map do |attr|
            value = record.send(attr)
            case value
            when ActiveStorage::Attached::One
              value.attached? ? url_for(value) : ""
            else
              value
            end
          end
        end
      else
        # Add an empty example row if no data present
        csv << Array.new(attributes.size, "")
      end
    end

    send_data csv_data,
              filename: "#{params[:model]}_sample.csv",
              type: "text/csv"
  end


  def import
    uploaded_file = params[:file]
    model_name = params[:model]
    file_content = uploaded_file.read
    original_filename = uploaded_file.original_filename
    
    ImportModelDataJob.perform_later(model_name, file_content, original_filename)
    render json: { status: "ok" }
  end

  def import_progress
    model_name = params[:model]
    progress = Rails.cache.read("import_progress_#{model_name}") || { status: "pending", progress: 0 }

    render json: progress
  end

  def sample
    model = params[:model].constantize
    headers = model.column_names - ["id", "created_at", "updated_at"]

    csv_data = CSV.generate(headers: true) do |csv|
      csv << headers
    end

    send_data csv_data, filename: "#{model.name.downcase}_sample.csv"
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

  def permitted_params
    model_key = params[:model].singularize.underscore
    allowed = @model_class.column_names - %w[id created_at updated_at]
    params.require(model_key).permit(allowed.map(&:to_sym))
  end
end
