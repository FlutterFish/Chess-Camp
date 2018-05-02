class NewAdmin < ActiveRecord::Migration[5.1]
  def up
    admin = User.new
    admin.username = "fish"
    admin.email = "admin@example.com"
    admin.phone = "4123456789"
    admin.password = "secret"
    admin.password_confirmation = "secret"
    admin.role = "admin"
    admin.save
    
    adminIns = Instructor.new
    adminIns.first_name = "Zehaotian"
    adminIns.last_name = "Lin"
    adminIns.bio = "The best chess instructor in the world."
    adminIns.user_id = admin.id
    adminIns.save
    
  end
  def down
    ins = Instructor.find_by_first_name "Zehaotian"
    Instructor.delete ins
    admin = User.find_by_username "fish"
    User.delete admin
  end
end
