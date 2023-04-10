class ErrorSerializer
  def initialize(error_object)
    @error_object = error_object
  end

  def serialized_json
    {
      errors: [
        {
          status: @error_object.status,
          detail: @error_object.detail,
          code:   @error_object.code
        }
      ]
    }
  end
end
