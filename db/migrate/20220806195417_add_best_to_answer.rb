class AddBestToAnswer < ActiveRecord::Migration[7.0]
  def change
    add_column :answers, :best, :boolean, default: false
  end
end
