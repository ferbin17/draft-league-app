class Competetion < ApplicationRecord
  has_many :teams, :primary_key => :league_id, :foreign_key => :league_id
  has_many :match_statistics, :primary_key => :league_id, :foreign_key => :league_id
  has_many :goal_statistics, :primary_key => :league_id, :foreign_key => :league_id
  has_many :goal_average_statistic, :primary_key => :league_id, :foreign_key => :league_id
  belongs_to :country
  TYPE = {"League" => 1, "Cup" => 2}
end
