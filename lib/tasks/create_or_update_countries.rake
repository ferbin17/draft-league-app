require 'uri'
require 'net/http'
require 'openssl'

namespace :draft_app do
  desc 'Fetch and contruct country database'
  task :fetch_and_construct_country_database => :environment do
    log = Logger.new('log/country_data_task.log')
    start_time = Time.now
    log.info "Country data task started at #{start_time}"  
    url = URI("#{AppConfig['data_api']['api_link']}/countries")
    # url = URI("#{AppConfig['data_api']['api_demo_link']}/countries")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(url)
    request["x-rapidapi-host"] = AppConfig["data_api"]["x-rapidapi-host"]
    request["x-rapidapi-key"] = AppConfig["data_api"]["x-rapidapi-key"]
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