# app/jobs/import_model_data_job.rb
require 'csv'

class ImportModelDataJob < ApplicationJob
  queue_as :default
  
  def perform(model_name, file_content, original_filename)
    # Write content to temp file inside the job
    file_path = Rails.root.join('tmp', "#{SecureRandom.hex}_#{original_filename}")
    File.open(file_path, 'wb') { |f| f.write(file_content) }
    
    begin
      model_class = model_name.classify.constantize
      rows = CSV.read(file_path, headers: true)
      total = rows.size
      processed = 0
      
      rows.each do |row|
        model_class.create!(row.to_h)
        processed += 1
        
        # Save progress in cache
        Rails.cache.write("import_progress_#{model_name}", {
          status: "in_progress",
          progress: ((processed.to_f / total) * 100).round,
          processed: processed,
          total: total
        })
      end
      
      # Mark as completed
      Rails.cache.write("import_progress_#{model_name}", {
        status: "completed",
        progress: 100,
        processed: total,
        total: total
      })
      
    rescue => e
      # Handle errors and save to cache
      Rails.cache.write("import_progress_#{model_name}", {
        status: "failed",
        error: e.message,
        progress: ((processed.to_f / total) * 100).round
      })
      raise e # Re-raise so Sidekiq knows it failed
      
    ensure
      # Always clean up the temp file
      File.delete(file_path) if File.exist?(file_path)
    end
  end
end