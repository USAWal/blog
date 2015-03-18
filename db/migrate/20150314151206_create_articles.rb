class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title,    null: false
      t.text   :body,     null: false
      t.text   :html_body
      t.text   :text_body

      t.timestamps null: false
    end
  end
end
