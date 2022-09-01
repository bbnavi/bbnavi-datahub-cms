# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :verify_current_user
  before_action :init_graphql_client
  before_action :load_category_list

  def verify_current_user
    return redirect_to log_in_path if session["current_user"].blank?

    user_data = {
      email: session["current_user"]["email"],
      authentication_token: session["current_user"]["authentication_token"],
      applications: session["current_user"]["applications"],
      roles: session["current_user"]["roles"],
      permission: session["current_user"]["permission"]
    }

    @current_user = User.new(user_data)
  end

  def init_graphql_client
    @smart_village = SmartVillageApi.new(user: @current_user).client
  end

  def load_category_list
    results = @smart_village.query <<~GRAPHQL
      query {
        categories {
          id
          name
        }
      }
    GRAPHQL

    @categories = results.data.categories
  end

  private

    # check for present values recursively
    def nested_values?(value_to_check, result = [])
      result << true if value_to_check.class == String && value_to_check.present?

      if value_to_check.class == Array
        value_to_check.each do |value|
          nested_values?(value, result)
        end
      elsif value_to_check.class.to_s.include?("Hash")
        value_to_check.each do |_key, value|
          nested_values?(value, result)
        end
      end

      result
    end
end
