#!/usr/bin/env ruby

require 'date'

class GeneaPerson
    attr_reader :id, :sex, :first_name, :middle_name, :last_name, :birthday, :deathday, :alive, :comments
    attr_accessor :parents, :families, :events

    def initialize(graph, id, first_name, middle_name, last_name, sex, birthday, deathday, alive, comments)
        @graph = graph
        @id = id
        @first_name = first_name
        @middle_name = middle_name
        @last_name = last_name
        @sex = sex
        @birthday = birthday
        @deathday = deathday
        @alive = alive
        @comments = comments
        @parents = nil
        @families = []
    end

    def name()
        if @first_name == nil and @middle_name == nil and @last_name == nil
            return id
        end

        name = nil
        if @first_name != nil
            name = @first_name
        else
            name = "???"
        end
        if @middle_name != nil
            name += " #{@middle_name}"
        end
        if @last_name != nil
            name += " #{@last_name}"
        else
            name += "???"
        end
        name
    end

    def is_root?()
        @graph.roots.include?(self)
    end

    def is_leaf?()
        @graph.leaves.include?(self)
    end
end
