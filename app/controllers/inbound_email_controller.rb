class InboundEmailController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def create
    @listing = Listing.create_from_postmark(Postmark::Mitt.new(request.body.read))

    if @listing.url
      @listing.save
      Resque.enqueue(FetchListingData, @listing.id)
      render :text => "Created a Listing!", :status => :created
    else
      render :text => "Didn't Create a Listing!", :status => :created
    end

  end
end
