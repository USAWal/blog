require 'open-uri'

namespace :articles do
  desc "Creates an article"
  task create: :environment do
    Article.create title: 'carrierwaveuploader/carrierwave', body: open("https://raw.githubusercontent.com/carrierwaveuploader/carrierwave/master/README.md") { |page| page.read }
  end

end
