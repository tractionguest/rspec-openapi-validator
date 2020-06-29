class RspecContracts::ResponseValidator
  class << self
    def validate_response(op, resp)
      op.validate_response(resp, opts)
    rescue OpenAPIParser::OpenAPIError => e
      raise RspecContracts::Error::ResponseValidation.new(e.message) if RspecContracts.config.response_validation_mode == :raise
    
      RspecContracts.config.logger.error "Contract validation warning: #{e.message}"
      RspecContracts.config.logger.error "Response was: #{resp.pretty_inspect}"
    end

    def opts
      OpenAPIParser::SchemaValidator::ResponseValidateOptions.new(strict: RspecContracts.config.strict_response_validation)
    end
  end
end