#!/usr/bin/env ruby

class GeneaGraph
    attr_reader :people, :families, :roots, :leaves

    def initialize()
        @ready = false
        @people = {}
        @families = []
        @roots = []
        @leaves = []
    end

    def add_person(person)
        id = person.id()
        if has_person?(id)
            return false
        end

        @people[id] = person
        reorganize!()
        return true
    end

    def add_family(family)
        @families << family
        reorganize!()
        return true
    end

    def has_person?(id)
        @people.has_key?(id)
    end

    def person(id)
        @people[id]
    end

    def reorganize!()
        if not @ready
            return
        end

        @roots = []
        @leaves = []
        @people.each do |id, person|
            if person.parents != nil and person.parents.parent1 == nil and person.parents.parent2 == nil
                @roots.push(person)
            end
            if person.families.empty?()
                @leaves.push(person)
            end
        end
    end

    def finished!()
        @ready = true
        reorganize!()
    end
end
