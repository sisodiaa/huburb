class SearchesController < ApplicationController
  before_action :total_records, only: [:show]
  skip_before_action :reset_search_state, only: [:show]

  def index
  end

  def show
    pages = Page
            .with_category(params[:category])
            .nearby(current_user_location)
            .order_by_distance(current_user_location)
            .offset(results_offset)
            .limit(results_per_page)

    @results = Search::results pages
    @current_page = current_page
    @prev, @next = Search::prev_and_next_pages @current_page
  end

  def create
    session[:coordinates] ||= "POINT(#{params[:longitude]} #{params[:latitude]})"
    head :no_content
  end

  private
  def total_records
    Search::total_records ||= Page
                              .with_category(params[:category])
                              .nearby(current_user_location)
                              .order_by_distance(current_user_location)
                              .count
  end

  def current_page
    params.has_key?(:page) ? params[:page].to_i : 1
  end

  def current_user_location
    "SRID=4326;#{session[:coordinates]}"
  end

  def results_offset
    (current_page - 1) * results_per_page
  end

  def results_per_page
    Search::results_per_page
  end
end
