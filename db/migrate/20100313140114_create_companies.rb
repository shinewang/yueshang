class CreateCompanies < ActiveRecord::Migration
  def self.up
    create_table :companies do |t|
      t.string :name
      t.text :introduction
      t.string :contact_person
      t.string :tel
      t.string :mobile
      t.string :email
      t.string :qq
      t.string :msn
      t.string :fax
      t.string :address
      t.string :zip
      t.string :site
      t.text :remark
      t.integer :category_id
      t.integer :status

      t.timestamps
    end
  end

  def self.down
    drop_table :companies
  end
end
