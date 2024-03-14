require 'test_helper'

class ArchiveExpiredPublishedAds < ActiveSupport::TestCase
  test 'that task will archive expired published ads' do
    published_ad = advertisements(:discount)
    published_ad.stub(:status_verified?, true) do
      published_ad.published_at = Time.zone.now - 15.days
      published_ad.save

      Huburb::Application.load_tasks
      Rake::Task['ads:archive'].invoke

      assert published_ad.reload.archived?
    end
  end
end
