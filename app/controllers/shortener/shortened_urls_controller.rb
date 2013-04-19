require_dependency "shortener/application_controller"
require 'rqrcode-rails3'
require 'mini_magick'

module Shortener
  class ShortenedUrlsController < ApplicationController
    include ShortenerHelper

    respond_to :html, only: [:index, :show]
    respond_to :json

    before_filter :find_shortened_url, :except => [:index, :create]
    before_filter :find_all_shortened_urls, :only => [:index]

    def show
      respond_to do |format|
        format.json
        format.svg  { render :qrcode => short_url(@shortened_url), :level => :l, :unit => 10 }
        format.png  { render :qrcode => short_url(@shortened_url), :unit => 5 }
      end
    end

    def create
      @shortened_url = Shortener::ShortenedUrl.generate(params[:shortened_url])

      unless @shortened_url.save
        render json: @shortened_url.errors, status: :unprocessable_entity
      else
        render 'show'
      end
    end

    def update
      unless @shortened_url.update_attributes(params[:shortened_url])
        render json: @shortened_url.errors, status: :unprocessable_entity
      else
        render 'show'
      end
    end

    def destroy
      @shortened_url.destroy
      head :no_content
    end

    private
      def find_shortened_url
        @shortened_url = Shortener::ShortenedUrl.find(params[:id])
      end

      def find_all_shortened_urls
        @shortened_urls = Shortener::ShortenedUrl.all
      end
  end
end