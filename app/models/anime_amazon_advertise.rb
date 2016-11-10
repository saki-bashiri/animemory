class AnimeAmazonAdvertise < ActiveRecord::Base
  belongs_to :anime
  belongs_to :amazon_product
end