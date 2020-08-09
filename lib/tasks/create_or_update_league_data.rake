require 'uri'
require 'net/http'
require 'openssl'

namespace :draft_app do
  desc 'Fetch and contruct league database'
  task :fetch_and_construct_league_database => :environment do
    log = Logger.new('log/league_data_task.log')
    start_time = Time.now
    log.info "League data task started at #{start_time}"
    url = URI("https://api-football-v1.p.rapidapi.com/v2/leagues")
    # url = URI("https://www.api-football.com/demo/v2/leagues")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(url)
    request["x-rapidapi-host"] = 'api-football-v1.p.rapidapi.com'
    request["x-rapidapi-key"] = '7df93b8d1fmsh59b5df99ff2419bp1911a4jsnf45f8c592930'
    response = http.request(request)
    league_datas = JSON.parse(response.read_body, symbolize_names: true)[:api][:leagues]
    if league_datas.present?
      league_datas.each do |league_data|
        competetion = Competetion.find_or_create_by(league_id: league_data[:league_id].to_i)
        type_id = Competetion::TYPE[league_data[:type]].presence || 0
        country = Country.find_by_name(league_data[:country]).presence
        country_id = country.try(:id).presence || 0
        competetion.update(name: league_data[:name], type_id: type_id, country_id: country_id)
      end
    end
    end_time = Time.now
    duration = end_time - start_time
    log.info "League data task ended at #{end_time}"    
    log.info "League data task total time duration #{duration/60} mins"
  end
end