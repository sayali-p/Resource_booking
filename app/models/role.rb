class Role < ActiveRecord::Base
	belongs_to :company
	has_many :employees

	validates :designation, :department, :priority, presence: true
	validates :priority, numericality: { only_integer: true, greater_than: 0, less_than: 2147483647 }

	validates :designation, uniqueness:{scope: [:company_id,:department], message: "Designation in department should be unique"}
	validates :priority, uniqueness:{scope: :company_id, message: "Priority should be uniq across the company"}


	validate :is_name_admin?

	before_validation :lower_fields

	after_destroy :add_default_role

	def add_default_role 
		empty_role_id = self.company.roles.find_by_designation("none").id
		self.employees.each do |x| 
			x.skip_password_validation = true
			x.update(role_id: empty_role_id)
			byebug
		end
	end

	private 

	def is_name_admin?
		unless self.designation != 'admin' 
			self.errors[:admin_designation] << "=>You can't assign the admin designation to anthoer employees"
		end
	end

	def lower_fields
		self.designation.downcase!
		self.department.downcase!
	end

end
