require_relative 'test_helper'

ActiveRecord::Base.silence_stream(STDOUT) do
  ActiveRecord::Schema.define do

    create_table :users do |t|
      t.string  :name
      t.string  :email
      t.string  :phone
      t.integer :employee_number
      t.boolean :sysadmin
    end
  end
end

class User < ActiveRecord::Base
  attr_accessible :name, :email, :phone, :employee_number, :sysadmin

  scope :contactable,        where("email is not null OR phone is not null")
  scope :employee,           where("employee_number > 0")
end

u1 = User.new(name: 'Alex', email: nil, phone: nil, employee_number: 1, sysadmin: true)
u1.save

u2 = User.new(name: 'Jake', email: 'jake@example.com', phone: nil, employee_number: 2, sysadmin: true)
u2.save

u3 = User.new(name: 'Josh', email: 'josh@example.com', phone: nil, employee_number: 0, sysadmin: false)
u3.save

u4 = User.new(name: 'James', email: 'james@example.com', phone: '1800 000 000', employee_number: 3, sysadmin: false)
u4.save

describe ActiveRecord::Relation do
  describe 'active_record_not' do
    it "can provide a symbol to negate" do
      users = User.not(:contactable)
      users.must_equal([u1])
    end

    it "can provide a hash to negate" do
      users = User.not(sysadmin: true)
      users.must_equal([u3, u4])
    end

    it "can provide a string to negate" do
      users = User.not("employee_number like '1'")
      users.must_equal([u2, u3, u4])
    end

    it "can provide a scope to negate" do
      users = User.not(User.employee)
      users.must_equal([u3])
    end

    it "can be used in a chain" do
      users = User.where(sysadmin: true).not("name like 'Alex'")
      users.must_equal([u2])
    end
  end
end