module Api
  class AddressEligibilitiesController < Api::BaseController

    before_action :validate_params, only: [:eligible]

    def eligible
      if formatted_address.present?
        body = property.eligible
        render json: body.to_json, status: 200
      else
        render json: {message: "Address Not found"}, status: 404
      end
    end

    private

    def property
      Property.new(formatted_address)
    end

    def formatted_address
      @formatted_address ||= AddressParamsConverter.new(params[:address]).format
    end

    def validate_params
      unless params[:address].present?
        render json: { message: "address missing" }, status: 400
      end
    end
  end
end
