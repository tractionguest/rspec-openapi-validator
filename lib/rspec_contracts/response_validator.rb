# frozen_string_literal: true

module RspecContracts
  class ResponseValidator
    class << self
      def validate_response(op, resp)
        op.validate_response(resp, opts(has_content: resp.content_type.present?))
      rescue OpenAPIParser::OpenAPIError => e
        if RspecContracts.config.response_validation_mode == :raise
          raise RspecContracts::Error::ResponseValidation.new(e.message)
        end

        RspecContracts.config.logger.error "Contract validation warning: #{e.message}"
        RspecContracts.config.logger.error "Response was: #{resp}"
      end

      def opts(has_content: true)
        OpenAPIParser::SchemaValidator::ResponseValidateOptions.new(strict: has_content &&
                                                                    RspecContracts.config.strict_response_validation)
      end
    end
  end
end
