#!/usr/bin/env ruby

require 'date'

class GeneaFamily
    attr_reader :type, :parent1, :parent2, :issues, :begin, :end

    def initialize(type, parent1, parent2, issues, bdate, edate)
        @type = type
        @parent1 = parent1
        @parent2 = parent2
        @issues = issues
        @begin = bdate
        @end = edate

        create_links!()
    end

    def create_links!()
        if parent1 != nil
            parent1.families << self
        end
        if parent2 != nil
            parent2.families << self
        end
        issues.each do |child|
            child.parents = self
        end
    end

    def spouse(parent)
        parent == parent1 ? parent2 : parent1
    end

    def siblings(child)
        Array.new(issues - child)
    end
end
