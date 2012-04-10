class Role < ActiveRecord::Base

  SUPERUSER_ROLE_NAME = 'Administrator'
  RESEARCHER_ROLE_NAME = 'Researcher'

  ALL_ROLE_NAMES = [SUPERUSER_ROLE_NAME, RESEARCHER_ROLE_NAME]

  has_many :users

  validates :name, :presence => true, :uniqueness => {:case_sensitive => false}

  scope :by_name, order('name')
  scope :superuser_roles, where(name: SUPERUSER_ROLE_NAME)

  def researcher?
    name == RESEARCHER_ROLE_NAME
  end

end
