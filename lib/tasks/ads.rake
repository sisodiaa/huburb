namespace :ads do
  desc 'Archive expired published advertisements'
  task archive: :environment do
    puts 'Archiving expired published ads' unless Rails.env.test?

    Advertisement.published.each do |published_ad|
      published_ad.archived! if published_ad.expired_at < Time.zone.now
    end

    puts 'Expired published ads archived' unless Rails.env.test?
  end
end
