require 'uri'
require 'net/http'
require 'openssl'

namespace :draft_app do
  desc 'Update enabled league database'
  task :update_enabled_leagues_database => :environment do
    log = Logger.new('log/enabled_leagues_data_task.log')
    start_time = Time.now
    log.info "Update enabled league task started at #{start_time}"
    # enabled_leagues = Configuration.enabled_leagues.collect(&:league_id)
    enabled_leagues = [530, 524]
    enabled_leagues.each do |key|
      url = URI("#{AppConfig['data_api']['api_link']}/leagues/league/#{key}")
      # url = URI("#{AppConfig['data_api']['api_demo_link']}/leagues/league/#{key}")
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Get.new(url)
      request["x-rapidapi-host"] = AppConfig["data_api"]["x-rapidapi-host"]
      request["x-rapidapi-key"] = AppConfig["data_api"]["x-rapidapi-key"]
      response = http.request(request)
      league_data = JSON.parse(response.read_body, symbolize_names: true)[:api][:leagues].try(:first)
      if league_data.present?
        competetion = Competetion.find_or_create_by(league_id: league_data[:league_id].to_i)
        type_id = Competetion::TYPE[league_data[:type]].presence || 0
        country = Country.find_by_name(league_data[:country]).presence
        country_id = country.try(:id).presence || 0
        competetion.update(name: league_data[:name], type_id: type_id, country_id: country_id)
      end
    end
    end_time = Time.now
    duration = end_time - start_time
    log.info "Update enabled league task ended at #{end_time}"    
    log.info "Update enabled league task total time duration #{duration/60} mins"
  end
end