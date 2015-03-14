class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :article, null: false
      t.text       :body,    null: false

      t.timestamps null: false
    end
  end
end
