class SitemapsController < ApplicationController
  def index
    respond_to do |format|
      format.xml
    end
  end

  def index_page
    respond_to do |format|
      format.xml
    end
  end
end