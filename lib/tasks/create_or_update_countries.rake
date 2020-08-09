require 'uri'
require 'net/http'
require 'openssl'

namespace :draft_app do
  desc 'Fetch and contruct country database'
  task :fetch_and_construct_country_database => :environment do
    log = Logger.new('log/country_data_task.log')
    start_time = Time.now
    log.info "Country data task started at #{start_time}"
    url = URI("https://api-football-v1.p.rapidapi.com/v2/countries")
    # url = URI("https://www.api-football.com/demo/v2/countries")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(url)
    request["x-rapidapi-host"] = 'api-football-v1.p.rapidapi.com'
    request["x-rapidapi-key"] = '7df93b8d1fmsh59b5df99ff2419bp1911a4jsnf45f8c592930'
    response = http.request(request)
    country_datas = JSON.parse(response.read_body, symbolize_names: true)[:api][:countries]
    attributes = Country.column_names - ["id", "name", "created_at", "updated_at"]
    if country_datas.present?
      country_datas.each do |country_data|
        country = Country.find_or_create_by(name: country_data[:country])
        attributes.each do |attribute|
          country.send("#{attribute}=", country_data[attribute.to_sym]) if country_data.keys.include?(attribute.to_sym)
        end
        country.save
      end
    end
    end_time = Time.now
    duration = end_time - start_time
    log.info "Country data task ended at #{end_time}"    
    log.info "Country data task total time duration #{duration/60} mins"
  end
end