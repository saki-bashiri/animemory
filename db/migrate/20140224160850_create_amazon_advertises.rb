class CreateAmazonAdvertises < ActiveRecord::Migration
  def up
    create_table :amazon_products do |t|
      t.string  :asin, :null => false
      t.boolean :top_ad_flg, :null => false, :default => false
      t.boolean :lst_ad_flg, :null => false, :default => false
      t.timestamps
    end

    add_index :amazon_products, :asin, :name => "asin"
    add_index :amazon_products, :top_ad_flg, :name => "top_ad_flg"
    add_index :amazon_products, :lst_ad_flg, :name => "lst_ad_flg"

    create_table :anime_amazon_advertises do |t|
      t.integer :anime_id, :null => false
      t.integer :amazon_product_id, :null => false
    end

    add_index :anime_amazon_advertises, :anime_id, :name => "anime_id"
    add_index :anime_amazon_advertises, :amazon_product_id, :name => "amazon_product_id"
  end

  def down
    drop_table :amazon_products
    drop_table :anime_amazon_advertises
  end
end
