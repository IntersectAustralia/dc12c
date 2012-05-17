class User < ActiveRecord::Base
  # Include devise modules
  devise :database_authenticatable, :ldap_authenticatable, :registerable, :lockable, :recoverable, :trackable, :validatable, :timeoutable

  belongs_to :role

  # Setup accessible attributes (status/approved flags should NEVER be accessible by mass assignment)
  attr_accessible :email, :password, :password_confirmation, :first_name, :last_name, :login_attribute, :dn, :is_ldap

  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :status
  validates_presence_of :login_attribute

  validate do |user|
    errors[:base] << "login attribute #{user.login_attribute.inspect} should eq one_id #{user.one_id.inspect}" if user.is_ldap && user.login_attribute != user.one_id
    errors[:base] << "login attribute #{user.login_attribute.inspect} should eq email #{user.email.inspect}" if !user.is_ldap && user.login_attribute != user.email
  end

  validates_presence_of :one_id, if: :is_ldap

  validates_length_of :first_name, :maximum => 255
  validates_length_of :last_name, :maximum => 255
  validates_length_of :email, :maximum => 255

  validates_inclusion_of :is_ldap, in: [true, false]

  with_options :if => :password_required? do |v|
    v.validates :password, :password_format => true
  end

  before_validation :initialize_status

  scope :approved, where(:status => 'A').order(:email)
  scope :deactivated_or_approved, where("status = 'D' or status = 'A' ").order(:email)
  scope :approved_superusers, joins(:role).merge(User.approved).merge(Role.superuser_roles)

  def self.existing_one_ids
    pluck :one_id
  end

#  def valid_password?(password) # clyfe's devise_ldap_authenticatable suggests this is required, but it does not seem to be required
#    begin
#      super(password)
#    rescue BCrypt::Errors::InvalidHash
#      false
#    end
#  end

  # Override Devise active for authentication method so that users must be approved before being allowed to log in
  # https://github.com/plataformatec/devise/wiki/How-To:-Require-admin-to-activate-account-before-sign_in
  def active_for_authentication?
    super && approved?
  end

  # Override Devise method so that user is actually notified right after the third failed attempt.
  def attempts_exceeded?
    self.failed_attempts >= self.class.maximum_attempts
  end

  # Overrride Devise method so we can check if account is active before allowing them to get a password reset email
  def send_reset_password_instructions
    if approved?
      generate_reset_password_token!
      ::Devise.mailer.reset_password_instructions(self).deliver
    else
      if deactivated?
        Notifier.notify_user_that_they_cant_reset_their_password(self).deliver
      end
    end
  end

  # Custom method overriding update_with_password so that we always require a password on the update password action
  # Devise expects the update user and update password to be the same screen so accepts a blank password as indicating that
  # the user doesn't want to change it
  def update_password(params={})
    current_password = params.delete(:current_password)

    result = if valid_password?(current_password)
               update_attributes(params)
             else
               self.errors.add(:current_password, current_password.blank? ? :blank : :invalid)
               self.attributes = params
               false
             end

    clean_up_passwords
    result
  end

  # Override devise method that resets a forgotten password, so we can clear locks on reset
  def reset_password!(new_password, new_password_confirmation)
    self.password = new_password
    self.password_confirmation = new_password_confirmation
    clear_reset_password_token if valid?
    if valid?
      unlock_access! if access_locked?
    end
    save
  end


  def approved?
    self.status == 'A'
  end

  def deactivated?
    self.status == 'D'
  end

  def rejected?
    self.status == 'R'
  end

  def deactivate
    self.status = 'D'
    save!(:validate => false)
  end

  def activate
    self.status = 'A'
    save!(:validate => false)
  end

  def check_number_of_superusers(id, current_user_id)
    current_user_id != id.to_i or User.approved_superusers.length >= 2
  end

  def self.get_superuser_emails
    approved_superusers.collect { |u| u.email }
  end

  def full_name
    "#{first_name} #{last_name}".strip
  end

  private

  def initialize_status
    self.status = "U" unless self.status
  end

end
