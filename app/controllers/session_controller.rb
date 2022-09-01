# frozen_string_literal: true

class SessionController < ApplicationController
  skip_before_action :verify_current_user
  skip_before_action :init_graphql_client
  skip_before_action :load_category_list


  def create
    if params[:email].present? && params[:password].present?
      @current_user = User.new(email: params[:email], password: params[:password])
      @current_user.sign_in
      if @current_user.valid?
        flash[:notice] = "Sie sind erfolgreich angemeldet"
        session["current_user"] = {}
        session["current_user"]["email"] = @current_user.email
        session["current_user"]["authentication_token"] = @current_user.authentication_token
        session["current_user"]["applications"] = @current_user.applications
        session["current_user"]["roles"] = @current_user.roles
        session["current_user"]["permission"] = @current_user.permission
        session["current_user"]["minio"] = @current_user.minio
        redirect_to root_path
      else
        flash[:error] = "E-Mail oder Passwort ist falsch"
        redirect_to log_in_path
      end
    end

  end

  def destroy
    session.destroy
    flash[:notice] = "Sie haben sich erfolgreich abgemeldet."
    redirect_to root_path
  end
end
