class ListingsController < ApplicationController
  # GET /listings
  # GET /listings.json

  can_edit_on_the_spot

  def index
    @listings = Listing.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @listings }
    end
  end

  def show
    @listing = Listing.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @listing }
    end
  end

  def new
    @listing = Listing.new

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @listing }
    end
  end

  def edit
    @listing = Listing.find(params[:id])
  end

  def create
    @listing = Listing.find_or_initialize_by_url(params[:listing][:url])
    if @listing.persisted?
      notice_msg = 'Listing already exists. Here it is.'
    else
      notice_msg = 'New listing was successfully added.'
    end

    respond_to do |format|
      if @listing.save
        Resque.enqueue(FetchListingData, @listing.id)
        format.html { redirect_to @listing, notice: notice_msg }
        format.json { render json: @listing, status: :created, location: @listing }
      else
        format.html { render action: "new" }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @listing = Listing.find(params[:id])

    respond_to do |format|
      if @listing.update_attributes(params[:listing])
        if (params[:commit] != "Add Note") && (params[:commit] != "Manually Update") && (params[:commit] != "Add")
          Resque.enqueue(FetchListingData, @listing.id)
          format.html { redirect_to @listing, notice: 'Listing is being updated in the background.' }
          format.json { head :no_content }

        elsif (params[:commit] == "Add")
            format.html { redirect_to :action => "index", notice: 'Added a new note.'}
            format.json { head :no_content }

        elsif (params[:commit] == "Manually Update")
          format.html { redirect_to @listing, notice: 'Listing was manually updated.' }
          format.json { head :no_content }

        elsif (params[:commit] == "Add Note")
          format.html { redirect_to @listing, notice: 'Listing was manually updated.' }
          format.json { head :no_content }

        elsif
          format.html { render action: "edit" }
          format.json { render json: @listing.errors, status: :unprocessable_entity }
        end
      end
    end
  end


  def update_all
    @listings = Listing.all

    @listings.each do |listing|
      Resque.enqueue(FetchListingData, listing.id)
    end
    flash[:notice] = 'Updating records in background.'
    redirect_to :action => 'index'
  end


  def destroy
    @listing = Listing.find(params[:id])
    @listing.destroy
    respond_to do |format|
      format.html{ redirect_to listings_url}
      format.xml { head :ok}
    end
  end
end
