class AccessRequestsController < ApplicationController
  def index
  end
  def pending
    @pending_access_requests = AccessRequest.pending_requests
  end
  def show
    @access_request = AccessRequest.find(params[:id])
  end

  def approve
    access_request = AccessRequest.find(params[:id])
    access_request.approve!

    redirect_to access_requests_path, notice: "The request was approved"
  end

  def reject
    access_request = AccessRequest.find(params[:id])
    access_request.reject!

    redirect_to access_requests_path, notice: "The request was rejected"
  end

  def approved
    page = params[:page]
    page = page.to_i <= 0 ? 1 : page
    @approved_access_requests = AccessRequest.approved_requests
    @approved_access_requests.sort_by(&:date_approved)
    @approved_access_requests = @approved_access_requests.paginate(page: page, per_page: APP_CONFIG['number_of_papyri_per_page'])
  end

  def rejected
    @rejected_access_requests = AccessRequest.rejected_requests
  end
end
