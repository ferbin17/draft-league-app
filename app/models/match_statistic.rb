class MatchStatistic < ApplicationRecord
  belongs_to :competetion, :primary_key => :league_id, :foreign_key => :league_id
  belongs_to :team, :primary_key => :team_id, :foreign_key => :team_id
end
