class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def index
    @profiles = Profile.all
  end

  def import
    CsvMasterDataService.new(Profile, profile_file_params).import_csv
    redirect_to profiles_url, notice: 'Data imported'
  end

  def destroy_all
    Profile.destroy_all
    redirect_to profiles_url, notice: 'All data destroyed'
  end

  def profile_file_params
    params[:profile][:file]
  end
end
