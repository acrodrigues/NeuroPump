class CivilStatus < ActiveRecord::Base
  has_many :patients

  attr_accessible :description
end
