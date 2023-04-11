class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from Exception, with: :record_not_found

  def check_content_type
    return if request.content_type == "application/json"

    bad_request(["JSON content type required"]) and return
  end

  def bad_request(messages)
    detail = "Validation Failed: #{messages.join(', ')}"
    error = Error.new(detail, "BAD REQUEST", 400)
    render json: ErrorSerializer.new(error).serialized_json, status: :bad_request
  end

  private

  def record_not_found(exception)
    error = Error.new(exception.message, "NOT FOUND", 404)
    render json: ErrorSerializer.new(error).serialized_json, status: :not_found
  end
end
