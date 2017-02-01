class AddColumToCard < ActiveRecord::Migration
  def change
    add_column :cards, :card_verification, :text
    add_column :cards, :card_number, :string
  end
end
