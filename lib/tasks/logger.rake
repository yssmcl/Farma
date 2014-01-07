# encoding: utf-8
namespace :logger do
   task :analyze => :environment do
     system "request-log-analyzer log/#{Rails.env}.log"
   end
end
