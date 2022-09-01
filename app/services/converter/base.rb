module Converter
  class Base
    def build_mutation(name, data, update = false, return_keys = "id")
      data = cleanup(data) unless name.downcase.include?("update") || update
      data = convert_to_json(data)
      data = convert_keys_to_camelcase(data)
      data = remove_quotes_from_keys(data)
      data = remove_quotes_from_boolean_values(data)

      # remove leading and tailing curly braces
      data = data.gsub(/^\{/, "").gsub(/\}$/, "")

      "mutation { #{name} (forceCreate: true, #{data}) { #{return_keys} } }"
    end

    def cleanup(data)
      data.delete :id

      data
    end

    def convert_to_json(data)
      JSON.parse(data.to_json)
    end

    def convert_keys_to_camelcase(data)
      data.deep_transform_keys { |key| key.to_s.camelize(:lower) }
    end

    def remove_quotes_from_keys(data)
      json_string = data.to_json
      json_string.scan(/"\w*":/).uniq.each do |key|
        json_string.gsub!(key, key.delete('"'))
      end

      json_string
    end

    def remove_quotes_from_boolean_values(data)
      data.gsub!(":\"true\"", ":true")

      data
    end

    def send_mutation(mutation, token)
      url = Rails.application.credentials.target_server[:url]
      response = ApiRequestService.new(url, nil, nil, {query: mutation}, { Authorization: token }).post_request
    end
  end
end
