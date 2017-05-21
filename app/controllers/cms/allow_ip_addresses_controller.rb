class Cms::AllowIpAddressesController < Cms::ApplicationController
  before_action :check_admin
  def new
    @allow_ip_address = AllowAddressIp.new
  end

  def create
    AllowAddressIp.create allow_ip_address_params
    redirect_to cms_allow_ip_addresses_url
  end

  def destroy
    AllowAddressIp.find(params[:id]).delete
    redirect_to cms_allow_ip_addresses_url
  end

  def allow_ip_address_params
    params.require(:allow_address_ip).permit(:ip_address)
  end
end
