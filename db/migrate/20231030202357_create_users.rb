class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :first_name, nil: false
      t.string :last_name, nil: false
      t.string :email, nil: false, index: true, uniq: true

      t.timestamps
    end
  end
end
