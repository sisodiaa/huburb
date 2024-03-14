module Search
  class Result
    attr_accessor :name, :link

    def initialize(result)
      @name = result.name
      @category = result.category
      @coordinates = result.address.coordinates
      @link = if Rails.env.production?
                "/demo/pages/#{result.pin}"
              else
                "/pages/#{result.pin}"
              end
    end
  end

  @total_records = nil

  def self.results results
    results.map do |result|
      Result.new(result)
    end
  end

  def self.total_records= count
    @total_records = count
  end

  def self.total_records
    @total_records
  end

  def self.results_per_page
    if Rails.env.test?
      1
    else
      5
    end
  end

  def self.prev_and_next_pages current_page
    _prev = _next = nil
    _prev = current_page - 1 if current_page > 1
    _next = current_page + 1 unless current_page == total_pages
    [_prev, _next]
  end

  def self.total_pages
    (@total_records.to_f / results_per_page).ceil
  end

  private_class_method :total_pages
end
