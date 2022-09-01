# frozen_string_literal: true

class SurveyCommentsController < ApplicationController
  def index
    results = @smart_village.query <<~GRAPHQL
      query {
        comments: surveyComments(
          surveyId: #{params[:survey_id]}
        ) {
          id
          surveyPollId
          message
          createdAt
          visible
        }
      }
    GRAPHQL

    @survey_comments = results.data.comments
  end
end
