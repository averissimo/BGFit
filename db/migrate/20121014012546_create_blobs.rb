class CreateBlobs < ActiveRecord::Migration
  def change
    create_table :blobs do |t|
      t.binary :data, :limit => 10.megabyte
      t.references :blobable, polymorphic: true

      t.timestamps
    end
    add_index :blobs, :blobable_id
  end
end
