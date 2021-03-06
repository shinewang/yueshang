require 'digest/sha1'
class Account < ActiveRecord::Base
  
  # ---------------------------------------
  # The following code has been generated by role_requirement.
  # You may wish to modify it to suit your need
  has_and_belongs_to_many :roles
  
  # has_role? simply needs to return true or false whether a user has a role or not.  
  # It may be a good idea to have "admin" roles return true always
  def has_role?(role_in_question)
    @_list ||= self.roles.collect(&:name)
    return true if @_list.include?("admin")
    (@_list.include?(role_in_question.to_s) )
  end
  # ---------------------------------------
  
  # Virtual attribute for the unencrypted password
  attr_accessor :password

  validates_presence_of     :login, :email
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :login,    :within => 3..30
  validates_length_of       :email,    :within => 3..60
  validates_length_of       :password, :within => 6..20, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_format_of :login,
                      :with => /^(?:\xe4[\xb8-\xbf][\x80-\xbf]|[\xe5-\xe8][\x80-\xbf][\x80-\xbf]|\xe9[\x80-\xbd][\x80-\xbf]|\xe9\xbe[\x80-\xa5]|[A-Za-z0-9_])+$/n,
                      :message => "只能包含中文或英文字符、数字和下划线"
  validates_format_of :email,
                      :with => /^[A-Z0-9._%-]+@([A-Z0-9-]+\.)+[A-Z]{2,4}$/i,
                      :message => "必须输入有效的Email地址"
  validates_uniqueness_of   :login, :email, :case_sensitive => false
  
  before_save :encrypt_password
  before_create :make_activation_code 
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :password, :password_confirmation, :enable

  # Activates user and send email
  def activate!
    self.activation_code = nil
    self.activated_at = Time.now.utc
    save(false)
    @activated = true
  end

  # Activates user without send email
  def activate
    self.activation_code = nil
    self.activated_at = Time.now.utc
    save(false)
  end

  def active?
    # the existence of an activation code means they have not activated yet
    activation_code.nil?
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find :first, :conditions => ['login = ? and activation_code IS NULL', login] # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 1.months
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  def forgot_password
    @forgotten_password = true
    self.make_password_reset_code
  end

  def reset_password
    # First update the password_reset_code before setting the
    # reset_password flag to avoid duplicate email notifications.
    # update_attributes(:password_reset_code => nil)
    self.password_reset_code = nil
    self.password_reset_code_until = nil
    save
    @reset_password = true
  end

  def lost_activation
    @lost_activation = true
  end

  def password_reset_code_expire?
    password_reset_code_until? && password_reset_code_until < Time.now.utc
  end
  
  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end

  def recently_forgot_password?
    @forgotten_password
  end

  def recently_reset_password?
    @reset_password
  end

  def recently_created?
    @created
  end

  def lost_activation?
    @lost_activation
  end

  def self.member_list(page)
		paginate :all,
						 :per_page => 50, :page => page,
        		 :conditions => ['enable = ? and activation_code IS NULL', true],
        		 :order => 'login'
	end

	def self.administrative_member_list(page)
		paginate :all,
						 :per_page => 50, :page => page,
        		 :order => 'login'
	end

  def record
    "#{id}: #{login}"
  end

  protected
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end
      
    def password_required?
      crypted_password.blank? || !password.blank?
    end
    
    def make_activation_code
      self.activation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
      @created = true
    end

    def make_password_reset_code
      self.password_reset_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
      self.password_reset_code_until = 3.days.from_now.utc
    end
    
end
