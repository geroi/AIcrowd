class MembersController < ApplicationController
  before_action :authenticate_participant!, except: [:show]
  before_action :set_organizer

  def index
    @challenges = @organizer.challenges
    @members    = @organizer.participants
  end

  def new
    @challenges = @organizer.challenges
    @members    = @organizer.participants
  end

  def create
    participant   = Participant.where(email: strong_params[:email]).first
    flash[:error] = "No crowdAI participant can be found with that email address" if participant.blank?
    flash[:info]  = "Participant added as an Organizer" if participant.present? && participant.organizers << @organizer
    redirect_to organizer_members_path(@organizer)
  end

  def destroy
    participant = Participant.friendly.find(params[:id])
    @organizer.participants.destroy(participant)
    redirect_to organizer_members_path(@organizer)
  end

  private

  def strong_params
    params.require(:member).permit(:email)
  end

  def set_organizer
    @organizer = Organizer.friendly.find(params[:organizer_id])
  end
end
