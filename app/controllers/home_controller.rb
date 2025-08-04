require_dependency Rails.root.join('app', 'services', 'geo_ip_service').to_s

class HomeController < ApplicationController
  before_action :forbid_login_user,{only:[:top]}

  def top
    @ip = request.remote_ip
    @location = GeoIpService.new(@ip).lookup

    if @location
      @latitude = @location[:latitude]   # 緯度
      @longitude = @location[:longitude] # 経度
    end
    

  end

  def about
  end

end
