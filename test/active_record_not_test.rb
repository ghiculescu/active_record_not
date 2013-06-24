require_relative 'test_helper'

ActiveRecord::Base.silence_stream(STDOUT) do
  ActiveRecord::Schema.define do

    create_table :customers do |t|
      t.string :name
    end

    create_table :organisations do |t|
      t.string :name
      t.references :customer
    end

    create_table :users do |t|
      t.string  :name
      t.string  :email
      t.string  :phone
      t.integer :employee_number
      t.boolean :sysadmin
      t.references :organisation
    end
  end
end

class Customer < ActiveRecord::Base
  attr_accessible :name

  has_many :organisations
end

class Organisation < ActiveRecord::Base
  attr_accessible :name

  has_many :users
  belongs_to :customer
end

class User < ActiveRecord::Base
  attr_accessible :name, :email, :phone, :employee_number, :sysadmin, :organisation_id

  belongs_to :organisation

  scope :contactable, where("email is not null OR phone is not null")
  scope :employee, where("employee_number > 0")
end

c1 = Customer.create(name: 'Dave')

org1 = c1.organisations.create(name: 'Organisation')
u1 = org1.users.create(name: 'Alex', email: nil, phone: nil, employee_number: 1, sysadmin: true)
u2 = org1.users.create(name: 'Jake', email: 'jake@example.com', phone: nil, employee_number: 2, sysadmin: true)

org2 = c1.organisations.create(name: 'Other Organisation')
u3 = org2.users.create(name: 'Josh', email: 'josh@example.com', phone: nil, employee_number: 0, sysadmin: false)
u4 = org2.users.create(name: 'James', email: 'james@example.com', phone: '1800 000 000', employee_number: 3, sysadmin: false)

c2 = Customer.create(name: 'Mike')

org3 = c2.organisations.create(name: 'Another Organisation')
u5 = org3.users.create(name: 'Chris', email: nil, phone: nil, employee_number: 11, sysadmin: true)
u6 = org3.users.create(name: 'Rob', email: 'rob@example.com', phone: nil, employee_number: 22, sysadmin: true)

org4 = c2.organisations.create(name: 'Yet Another Organisation')
u7 = org4.users.create(name: 'Steve', email: 'steve@example.com', phone: nil, employee_number: 0, sysadmin: false)
u8 = org4.users.create(name: 'Dan', email: 'dan@example.com', phone: '1300 000 000', employee_number: 33, sysadmin: false)

describe ActiveRecord::Relation do
  describe 'active_record_not' do
    it "can provide a symbol to negate" do
      users = User.not(:contactable)
      users.must_equal [u1, u5]
    end

    it "can provide a hash to negate" do
      users = User.not(sysadmin: true)
      users.must_equal [u3, u4, u7, u8]
    end

    it "can provide a string to negate" do
      users = User.not("employee_number like '1'")
      users.must_equal [u2, u3, u4, u5, u6, u7, u8]
    end

    it "can provide a scope to negate" do
      users = User.not(User.employee)
      users.must_equal [u3, u7]
    end

    it "can be used in a chain" do
      users = User.where(sysadmin: true).not("name like 'Alex'")
      users.must_equal [u2, u5, u6]
    end

    it "can be used in a join" do
      users = User.joins(:organisation).not(organisation_id: org1.id)
      users.must_equal [u3, u4, u5, u6, u7, u8]
    end

    it "can be used in a join with a string" do
      users = User.joins(:organisation).not('organisations.name' => 'Organisation')
      users.must_equal [u3, u4, u5, u6, u7, u8]
    end

    it "can be used in a more complex join with a string" do
      users = User.joins(:organisation => :customer).not('customers.name' => 'Dave')
      users.must_equal [u5, u6, u7, u8]
    end
  end
end