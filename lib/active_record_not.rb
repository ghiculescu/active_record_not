# -*- encoding : utf-8 -*-

module ActiveRecordNot
  def not(args)
    left = self
    last_left_constraint = left.constraints.last

    case args
    when Symbol
      constrainted_not = left.unscoped.send(args).constraints.last.not # eg. User.not(:active), where User#active is a scope
    when Hash
      constrainted_not = left.unscoped.where(args).constraints.last.not # eg. User.not(active: true), so syntax like #where
    when String
      constrainted_not = left.unscoped.where(args).constraints.last.not # eg. User.not("is_active = 't'h;"), so syntax like #where
    when ActiveRecord::Relation
      constrainted_not = args.constraints.last.not # eg. User.not(User.active), where User#active is a scope
    end

    merged_not = last_left_constraint.nil? ? constrainted_not : last_left_constraint.and(constrainted_not)

    left.where_values = [merged_not]
    left
  end
end

ActiveRecord::Relation.send(:include, ActiveRecordNot)
ActiveRecord::Querying.send(:delegate, :not, :to => :scoped)