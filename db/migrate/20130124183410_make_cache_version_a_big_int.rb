class MakeCacheVersionABigInt < ActiveRecord::Migration
  def up
    change_column :clients, :cache_version, :bigint
  end

  def down
    change_column :clients, :cache_version, :integer
  end
end
