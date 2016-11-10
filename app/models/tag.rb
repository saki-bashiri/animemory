class Tag < ActiveRecord::Base
  attr_accessible :name, :updated_at, :created_at

  has_many :tag_groups
  has_many :animes, :through => :tag_groups

  MAX_LENGTH = 50

  validates_presence_of :name
  validates_uniqueness_of :name

  def validate
    errors.add "タグ名が長すぎます。" if self.name.jlength > 50
  end

  def find_or_create_by_name(name)
    tag = self.first(:conditions => ["name = ?", name])
    if tag.present?
      return tag
    else
      tag = Tag.new
      tag.name = name.to_s
      tag.save!
      return tag
    end
  end
end
