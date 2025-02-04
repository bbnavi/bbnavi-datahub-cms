# frozen_string_literal: true

class DashboardController < ApplicationController
  def index
    @point_of_interest_count_for_category = {}
    @current_user.roles["role_point_of_interest_category_ids"].each do |possible_category_id|
      poi_results = @smart_village.query <<~GRAPHQL
        query {
          pointsOfInterest(categoryIds: "#{possible_category_id}" ) {
            id
            externalId
            name
            visible
            dataProvider{
              name
            }
            updatedAt
            createdAt
          }
        }
      GRAPHQL

      @point_of_interest_count_for_category[possible_category_id] = poi_results.data.points_of_interest.count
    end

    if helpers.visible_in_role?("role_news_item")
      news_results = @smart_village.query <<~GRAPHQL
        query {
          newsItems {
            id
          }
        }
      GRAPHQL

      @news_items = news_results.data.news_items
    end

    if helpers.visible_in_role?("role_event_record")
      event_results = @smart_village.query <<~GRAPHQL
        query {
          eventRecords {
            id
          }
        }
      GRAPHQL

      @events = event_results.data.event_records
    end

    if helpers.visible_in_role?("role_point_of_interest")
      poi_results = @smart_village.query <<~GRAPHQL
        query {
          pointsOfInterest() {
            id
          }
        }
      GRAPHQL

      @points_of_interest = poi_results.data.points_of_interest
    end

    if helpers.visible_in_role?("role_tour")
      tour_results = @smart_village.query <<~GRAPHQL
        query {
          tours {
            id
          }
        }
      GRAPHQL

      @tours = tour_results.data.tours
    end

    if helpers.visible_in_role?("role_job")
      job_results = @smart_village.query <<~GRAPHQL
        query {
          genericItems(genericType: "Job") {
            id
          }
        }
      GRAPHQL

      @jobs = job_results.data.generic_items
    end

    if helpers.visible_in_role?("role_offer")
      offer_results = @smart_village.query <<~GRAPHQL
        query {
          genericItems(genericType: "Offer") {
            id
          }
        }
      GRAPHQL

      @offers = offer_results.data.generic_items
    end

    if helpers.visible_in_role?("role_constuction_site")
      construction = @smart_village.query <<~GRAPHQL
        query {
          genericItems(genericType: "ConstructionSite") {
            id
          }
        }
      GRAPHQL

      @constructions = construction.data.generic_items
    end

    if helpers.visible_in_role?("role_waste_calendar")
      waste_location_results = @smart_village.query <<~GRAPHQL
        query {
          wasteAddresses(limit: 100) {
            id
          }
        }
      GRAPHQL

      @waste_locations = waste_location_results.data.waste_addresses
    end

    if helpers.visible_in_role?("role_survey")
      survey_results = @smart_village.query <<~GRAPHQL
        query {
          surveys {
            id
          }
        }
      GRAPHQL

      @surveys = survey_results.data.surveys
    end

    if helpers.visible_in_role?("role_static_contents")
      static_content_results = @smart_village.query <<~GRAPHQL
        query {
          staticContents: publicHtmlFiles {
            id
          }
        }
      GRAPHQL

      @static_contents = static_content_results.data.static_contents
    end
  end

end
