class IpToolsController < ApplicationController
  def new
  end

  def create
    @ip_input = params[:ip]
    @subnet_or_cidr = params[:subnet_or_cidr]
    begin
      @calculator = IpCalculator.new(@ip_input, @subnet_or_cidr)
    rescue ArgumentError => e
      flash.now[:alert] = e.message.split(', ').join('<br>').html_safe
      render :new and return
    end

  end
end
