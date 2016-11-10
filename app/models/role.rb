class Role < ActiveRecord::Base
  attr_accessible :name, :comment
  has_many :staffs
end
