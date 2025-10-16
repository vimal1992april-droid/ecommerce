# app/models/concerns/crudable.rb
module Crudable
  extend ActiveSupport::Concern

  included do
    class_attribute :crud_options
    self.crud_options = {
      listing: true,
      add: true,
      edit: true,
      import: true,
      export: true,
      delete: true,
    }
  end

  class_methods do
    def hide_crud(*features)
      features.each { |f| self.crud_options[f] = false }
    end
  end
end
