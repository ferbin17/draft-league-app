require 'uri'
require 'net/http'
require 'openssl'

namespace :draft_app do
  desc 'Update teams for enabled league database'
  task :update_teams_for_enabled_leagues_database => :environment do
    log = Logger.new('log/teams_for_enabled_leagues_data_task.log')
    start_time = Time.now
    log.info "Update teams for enabled league task started at #{start_time}"
    # enabled_leagues = Configuration.enabled_leagues.collect(&:league_id)
    enabled_leagues = [530, 524]
    enabled_leagues.each do |key|
      url = URI("https://api-football-v1.p.rapidapi.com/v2/teams/league/#{key}")
      # url = URI("https://www.api-football.com/demo/v2/teams/league/#{key}")
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Get.new(url)
      request["x-rapidapi-host"] = 'api-football-v1.p.rapidapi.com'
      request["x-rapidapi-key"] = '7df93b8d1fmsh59b5df99ff2419bp1911a4jsnf45f8c592930'
      response = http.request(request)
      teams_datas = JSON.parse(response.read_body, symbolize_names: true)[:api][:teams]
      attributes = Team.column_names - ["id", "country_id", "league_id", "created_at", "updated_at"]
      if teams_datas.present?
        teams_datas.each do |team_data|
          team = Team.find_or_create_by(team_id: team_data[:team_id].to_i)
          attributes.each do |attribute|
            team.send("#{attribute}=", team_data[attribute.to_sym]) if team_data.keys.include?(attribute.to_sym)
          end
          country = Country.find_by_name(team_data[:country]).presence
          country_id = country.try(:id).presence || 0
          team.country_id = country_id
          team.league_id = key
          if team.save && !team.stadium.present?
            stadium_attributes = team_data.keys.select{|x|x.match("venue")}
            new_stadium_data = {}
            stadium_data = team_data.select{|x, y| stadium_attributes.include?(x)}.each{|x, y| new_stadium_data[x.to_s.gsub("venue_", "").to_sym] = y }
            team.build_stadium(new_stadium_data)
            team.save
          end
        end
      end
    end
    end_time = Time.now
    duration = end_time - start_time
    log.info "Update teams for enabled league task ended at #{end_time}"    
    log.info "Update teams for enabled league task total time duration #{duration/60} mins"
  end
end

