class Team < ApplicationRecord
  has_one :stadium, class_name: "Stadium"
  has_many :match_statistics
  has_many :goal_statistics
  has_many :goal_average_statistic
  belongs_to :competetion, :primary_key => :league_id, :foreign_key => :league_id
  belongs_to :country
end
