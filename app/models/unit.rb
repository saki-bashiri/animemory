class Unit < ActiveRecord::Base
  attr_accessible :unit_id, :creator_id, :unit_sort
  belongs_to :unit_creator , :class_name => "Creator", :foreign_key => "unit_id"
  belongs_to :creator
end
