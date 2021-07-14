class SitemapsController < ApplicationController
  def index
    respond_to do |format|
      format.xml
    end
  end

  def robot
    respond_to do |format|
      format.txt
    end
  end
end