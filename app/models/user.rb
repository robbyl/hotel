class User < ActiveRecord::Base
  attr_accessor :password, :role, :old_password, :new_password, :confirm_password
  named_scope :active, :conditions => {:is_deleted => false}
  named_scope :inactive, :conditions => {:is_deleted => true}
  
   def before_save
    self.salt = random_string(8) if self.salt == nil
    self.hashed_password = Digest::SHA2.hexdigest(self.salt + self.password) unless self.password.nil?
    if self.new_record?
      self.admin, self.guest, self.employee = false, false, false
      self.admin    = true if self.role == 'Admin'
      self.guest  = true if self.role == 'Guest'
      self.employee = true if self.role == 'Employee'
#      self.parent = true if self.role == 'Parent'
#      self.is_first_login = true
    end
  end
  
  def self.authenticate?(username, password)
    u = User.find_by_username username
    u.hashed_password == Digest::SHA2.hexdigest(u.salt + password)
  end
  
  def random_string(len)
    randstr = ""
    chars = ("0".."9").to_a + ("a".."z").to_a + ("A".."Z").to_a
    len.times { randstr << chars[rand(chars.size - 1)] }
    randstr
  end
  
end
