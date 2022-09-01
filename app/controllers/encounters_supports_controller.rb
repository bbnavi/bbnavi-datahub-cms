class EncountersSupportsController < ApplicationController
  # display form to enter support ID
  def index
  end

  # form action from index page calling the show path
  def validate
    redirect_to encounters_support_path(params[:support_id])
  end

  # show user and encounter data for support ID if validated successfully
  def show
    result = validate_support_id

    if result && result.code == "200" && result.body.present?
      user_data = OpenStruct.new(JSON.parse(result.body))

      @user = user_data.to_h.as_json(except: :encounters)
      @encounters = user_data["encounters"]
    else
      flash[:error] = "Support-ID nicht gültig"
      redirect_to encounters_supports_path
    end
  rescue StandardError
    flash[:error] = "Es ist ein Fehler aufgetreten. Bitte erneut versuchen."
    redirect_to encounters_supports_path
  end

  # action from show page to verify a user
  def verify_user
    result = validate_support_id
    if result && result.code == "200" && result.body.present?
      encounter_server = SmartVillageApi.encounter_server_url
      uri = Addressable::URI.parse("#{encounter_server}/v1/support/verify_user.json")
      result = ApiRequestService.new(uri.to_s, nil, nil, user_id: params[:user_id]).get_request

      if result && result.code == "200" && result.body.present?
        flash[:success] = "Nutzer erfolgreich verifiziert"
        redirect_to encounters_support_path(params[:id])
      else
        flash[:error] = "Es ist ein Fehler aufgetreten. Bitte erneut versuchen oder neue Support-ID erstellen."
        redirect_to encounters_support_path(params[:id])
      end
    else
      flash[:error] = "Support-ID nicht gültig"
      redirect_to encounters_supports_path
    end
  rescue StandardError
    flash[:error] = "Es ist ein Fehler aufgetreten. Bitte erneut versuchen."
    redirect_to encounters_supports_path
  end

  private

    # validate the support ID against encounters server and main server
    def validate_support_id
      support_id = params[:id]

      return if support_id.blank?

      encounter_server = SmartVillageApi.encounter_server_url
      uri = Addressable::URI.parse("#{encounter_server}/v1/support/user_encounters.json")
      data_to_send = {
        support_id: support_id,
        server_url: SmartVillageApi.auth_server_url,
        auth_token: session["current_user"]["authentication_token"]
      }

      ApiRequestService.new(uri.to_s, nil, nil, data_to_send).get_request
    end
end
