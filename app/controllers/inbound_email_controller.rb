class InboundEmailController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def create
    
    @listing = Listing.new(params[:listing])
    if @listing.save
      Resque.enqueue(FetchListingData, @listing.id)
      redirect_to @listing, :notice => "Successfully created new listing."
    else
      render 'new'
    end
  end
end
