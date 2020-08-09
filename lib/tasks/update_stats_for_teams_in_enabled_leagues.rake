require 'uri'
require 'net/http'
require 'openssl'

namespace :draft_app do
  desc 'Update stats for teams in enabled league database'
  task :update_stats_for_teams_in_enabled_leagues_database => :environment do
    log = Logger.new('log/stats_for_teams_in_enabled_leagues_data_task.log')
    start_time = Time.now
    log.info "Update stats for teams in enabled league task started at #{start_time}"
    # enabled_leagues = Configuration.enabled_leagues
    enabled_leagues = [524]
    enabled_leagues.each do |key|
      competetion = Competetion.find_by_league_id(key)
      competetion.teams.each do |team|
        url = URI("https://api-football-v1.p.rapidapi.com/v2/statistics/#{competetion.league_id}/#{team.team_id}")
        # url = URI("https://www.api-football.com/demo/v2/statistics/#{competetion.league_id}/#{team.team_id}")
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        request = Net::HTTP::Get.new(url)
        request["x-rapidapi-host"] = 'api-football-v1.p.rapidapi.com'
        request["x-rapidapi-key"] = '7df93b8d1fmsh59b5df99ff2419bp1911a4jsnf45f8c592930'
        response = http.request(request)
        stats_datas = JSON.parse(response.read_body, symbolize_names: true)[:api][:statistics]
        if stats_datas.present?
          match_statistics = stats_datas[:matchs]
          goal_statistics = stats_datas[:goals]
          goal_average_statistics = stats_datas[:goalsAvg]
          
          match_statistics.each do |key, value|
            ms = MatchStatistic.find_or_create_by(league_id: competetion.league_id, team_id: team.team_id, category: key.to_s)
            ms.update(value)
          end
          
          goal_statistics.each do |key, value|
            gs = GoalStatistic.find_or_create_by(league_id: competetion.league_id, team_id: team.team_id, category: key.to_s)
            gs.update(value)
          end
          
          goal_average_statistics.each do |key, value|
            gas = GoalAverageStatistic.find_or_create_by(league_id: competetion.league_id, team_id: team.team_id, category: key.to_s)
            gas.update(value)
          end
          
        end
      end
    end
    end_time = Time.now
    duration = end_time - start_time
    log.info "Update stats for teams in enabled league task ended at #{end_time}"    
    log.info "Update stats for teams in enabled league task total time duration #{duration/60} mins"
  end
end