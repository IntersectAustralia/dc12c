class Role < ActiveRecord::Base

  SUPERUSER_ROLE_NAME = 'Administrator'

  has_and_belongs_to_many :permissions, :join_table => 'roles_permissions'
  has_many :users

  validates :name, :presence => true, :uniqueness => {:case_sensitive => false}

  scope :by_name, order('name')
  scope :superuser_roles, where(name: SUPERUSER_ROLE_NAME)

  def researcher?
    name == 'Researcher'
  end

  def has_permission(entity, action)
    permissions.each do |perm|
      if perm.entity == entity && perm.action == action
        return true
      end
    end
    false
  end

end
