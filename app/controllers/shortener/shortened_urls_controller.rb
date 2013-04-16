class Shortener::ShortenedUrlsController < ActionController::Base
  layout 'application'

  before_filter :find_shortened_url, :only => [:show, :update, :destroy]
  before_filter :find_all_shortened_urls, :only => [:index]

  def create
    @shortened_url = Shortener::ShortenedUrl.generate(params[:shortened_url])

    respond_to do |format|
      if @shortened_url.save
        format.html { redirect_to @shortened_url, notice: 'Shortened url was successfully created.' }
        format.json { render json: @shortened_url, status: :created, location: @shortened_url }
      else
        format.html { render action: "new" }
        format.json { render json: @shortened_url.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @shortened_url.update_attributes(params[:shortened_url])
        format.html { redirect_to @shortened_url, notice: 'Shortened url was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @shortened_url.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @shortened_url.destroy

    respond_to do |format|
      format.html { redirect_to shortened_urls_url }
      format.json { head :no_content }
    end
  end

  private
    def find_shortened_url
      @shortened_url = Shortener::ShortenedUrl.find(params[:id])
    end

    def find_all_shortened_urls
      @shortened_urls = Shortener::ShortenedUrl.all
    end
end
