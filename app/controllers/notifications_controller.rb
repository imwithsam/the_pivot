class NotificationsController < ApplicationController
  def create
    NotificationsMailer.contact(email_params).deliver_later

    redirect_to  :back, notice: "Your email has been sent."
  end

  private

  def email_params
    params.permit(:name, :email, :message)
  end
end
