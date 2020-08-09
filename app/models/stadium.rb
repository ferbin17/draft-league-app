class Stadium < ApplicationRecord
  self.table_name = "stadiums"
  belongs_to :team, :primary_key => :team_id, :foreign_key => :team_id
end
