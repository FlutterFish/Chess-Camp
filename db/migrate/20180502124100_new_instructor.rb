class NewInstructor < ActiveRecord::Migration[5.1]
  def up
    insUser = User.new
    insUser.username = "jennie"
    insUser.email = "jennie@example.com"
    insUser.phone = "4123336789"
    insUser.password = "secret"
    insUser.password_confirmation = "secret"
    insUser.role = "instructor"
    insUser.save
    
    ins = Instructor.new
    ins.first_name = "Jennie"
    ins.last_name = "Chen"
    ins.bio = "The second best chess instructor in the world."
    ins.user_id = insUser.id
    ins.save
    
  end
  def down
    insUser = Instructor.find_by_first_name "Jennie"
    Instructor.delete insUser
    ins = User.find_by_username "jennie"
    User.delete ins
  end
end

