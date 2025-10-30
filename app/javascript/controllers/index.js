// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
import FilePreviewController from "controllers/file_preview_controller"

eagerLoadControllersFrom("controllers", application)
application.register("file-preview", FilePreviewController)