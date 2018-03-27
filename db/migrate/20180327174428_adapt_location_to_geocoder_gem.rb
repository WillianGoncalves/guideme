class AdaptLocationToGeocoderGem < ActiveRecord::Migration[5.1]
  def change
    change_column :locations, :lat, :float
    change_column :locations, :lng, :float
    rename_column :locations, :lat, :latitude
    rename_column :locations, :lng, :longitude
    change_column_null :locations, :latitude, true
    change_column_null :locations, :longitude, true
    add_column :locations, :street, :string, null: false, default: ""
    add_column :locations, :district, :string, null: false, default: ""
    add_column :locations, :city, :string, null: false, default: ""
    add_column :locations, :state, :string, null: false, default: ""
    remove_column :locations, :address
  end
end
