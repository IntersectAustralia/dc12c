class Role < ActiveRecord::Base

  SUPERUSER_ROLE_NAME = 'Administrator'

  has_many :users

  validates :name, :presence => true, :uniqueness => {:case_sensitive => false}

  scope :by_name, order('name')
  scope :superuser_roles, where(name: SUPERUSER_ROLE_NAME)

  def researcher?
    name == 'Researcher'
  end

end
