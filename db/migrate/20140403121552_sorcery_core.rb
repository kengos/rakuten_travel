class SorceryCore < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string   :email,                      null: false
      t.string   :crypted_password,           null: false
      t.string   :salt,                       null: false
      t.integer  :failed_logins_count,        default: 0
      t.datetime :lock_expires_at,            default: nil
      t.string   :unlock_token,               default: nil
      t.datetime :last_login_at,              default: nil
      t.datetime :last_logout_at,             default: nil
      t.datetime :last_activity_at,           default: nil
      t.string   :last_login_from_ip_address, default: nil
      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, [:last_logout_at, :last_activity_at]
  end
end