class InboundEmailController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def create
    Listing.create_from_postmark(Postmark::Mitt.new(request.body.read))
    if @listing.save
      Resque.enqueue(FetchListingData, @listing.id)
      redirect_to @listing, :notice => "Successfully created new listing."
    else
      render 'new'
    end
    # @listing = Listing.new(params[:listing])
    # if @listing.save
    #   Resque.enqueue(FetchListingData, @listing.id)
    #   redirect_to @listing, :notice => "Successfully created new listing."
    # else
    #   render 'new'
    # end

    render :text => "Created a Listing!", :status => :created
  end
end
