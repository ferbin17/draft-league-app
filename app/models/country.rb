class Country < ApplicationRecord
  serialize :topLevelDomain
  serialize :callingCodes
  serialize :timezones
  has_many :competetions
end
