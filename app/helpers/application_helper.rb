module ApplicationHelper
  def all_models
    # Load all app/models files (in case Rails hasn't autoloaded them yet)
    Dir[Rails.root.join("app/models/**/*.rb")].each { |file| require_dependency file }

    # Get all ActiveRecord models except internal/system ones
    ApplicationRecord.descendants
                     .reject { |m| m.name.start_with?("ActiveStorage", "ActionText", "SchemaMigration", "Admin") }
                     .sort_by(&:name)
  end

  def model_icon(model_name)
    icons = {
      "user" => "fa-user",
      "role" => "fa-id-badge",
      "admin" => "fa-user-shield",
      "product" => "fa-box",
      "category" => "fa-tags",
      "order" => "fa-receipt",
      "event" => "fa-calendar-days",
      "ticket" => "fa-ticket",
      "blog" => "fa-pen-nib",
      "comment" => "fa-comments",
      "accesspoint" => "fa-wifi",
      "country" => "fa-globe"
    }

    # find icon by normalized name, fallback to default
    icons[model_name.to_s.downcase] || "fa-database"
  end
end
