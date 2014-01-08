# The Micropost migration
class CreateMicroposts < ActiveRecord::Migration
  def change
    create_table :microposts do |t|
      t.string :content
      t.integer :user_id

      t.timestamps # timestamps adds the created_at and updated_at columns
    end

    # Index on the user_id and created_at columns added. 
    # created_at is added because all the microposts are
    # expected to be retrieved in reverse order of creation.
    # By including both the user_id and created_at columns as an array,
    # we arrange for Rails to create a multiple key index, which means
    # that Active Record uses both keys at the same time.
    add_index :microposts, [:user_id, :created_at]
  end
end
