class AddNameDowncaseToAbility < ActiveRecord::Migration
  def change
    add_column :abilities, :name_downcase, :string
    add_index :abilities, :name_downcase
  end
end
