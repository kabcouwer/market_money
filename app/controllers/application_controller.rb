class ApplicationController < ActionController::API
  def bad_request(messages)
    detail = "Validation Failed: #{messages.join(', ')}"
    @error = Error.new(detail, "BAD REQUEST", 400)
    render json: ErrorSerializer.new(@error).serialized_json, status: :bad_request
  end
end
