# active_record_not

Adds #not to your ActiveRecord querying. This works similarly to #where, but inversed!

Note that this is supported natively in Rails 4, with slightly different syntax: http://blog.remarkablelabs.com/2012/12/not-equal-support-for-active-record-queries-rails-4-countdown-to-2013

## Installation

`gem install active_record_not`, or add active_record_not to your Gemfile and `bundle install`.

https://rubygems.org/gems/active_record_not

## Usage

Given a model...

	class User < ActiveRecord::Base
      attr_accessible :name, :email, :phone, :employee_number, :sysadmin
      ...
      scope :contactable,        where("email is not null OR phone is not null")
      scope :employee,           where("employee_number > 0")
      ...
	end

You could write...

	# Provide a symbol, which corresponds to a scope, to negate that scope.
	User.not(:contactable) # users that aren't contactable

	# Provide a scope explicitly, to negate it
	User.not(User.employee) # users that aren't employees

	# Provide a hash or string to negate it
	User.not(sysadmin: true) # users that aren't sysadmins
	User.not("employee_number like '1'") # users where the employee number doesn't contain a 1

You can also use `#not` within a chain of queries...

	User.where(sysadmin: true).not("name like 'Alex'")

## Credits

Inspired by [active_record_or](https://github.com/woahdae/active_record_or).

## Copyright

Copyright (c) 2013 Alex Ghiculescu. See LICENSE.txt for further details.