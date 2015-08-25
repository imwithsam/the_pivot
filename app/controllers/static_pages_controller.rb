class StaticPagesController < ApplicationController
  def index
    load_featured_events
  end
end
