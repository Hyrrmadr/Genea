#!/usr/bin/env ruby

require 'rubygems'
require 'json'

require_relative 'GeneaGraph'
require_relative 'GeneaPerson'
require_relative 'GeneaFamily'

module Genea
    def self.parse(file_path)
        file = File.open(file_path, "rb")
        contents = file.read()
        file.close()

        self.parse_str(contents)
    end

    def self.parse_str(contents)
        json_object = JSON.parse(contents)

        self.make_graph(json_object)
    end

    def self.make_graph(json_object)
        version = 1
        if json_object.has_key?("version")
            version = json_object.version
        end

        if version != 1
            raise ArgumentError, "Unknown version (#{version})"
        end

        if not json_object.has_key?("people")
            raise ArgumentError, "Doesn't contain the 'people' attribute (#{json_object})"
        end

        if not json_object['people'].kind_of?(Array)
            raise ArgumentError, "'people' attribute isn't an array (#{json_object['people']})"
        end

        graph = GeneaGraph.new()

        json_object['people'].each do |json_person|
            self.create_person(graph, json_person)
        end

        if json_object.has_key?('families')
            json_object['families'].each do |json_event|
                self.create_family(graph, json_event)
            end
        end

        graph.finished!()

        graph
    end

    def self.to_bool(str, json_object, attrib)
        if str == "true"
            return true
        elsif str == "false"
            return false
        else
            raise ArgumentError, "Unknown value for boolean attribute '#{attrib}' (#{json_object})"
        end
    end

    def self.create_person(graph, json_person)
        if not json_person.has_key?("id")
            raise ArgumentError, "Person object miss an 'id' attribute (#{json_person})"
        end

        id = json_person['id']
        if graph.has_person?(id)
            raise ArgumentError, "Two persons with the same 'id' attribute (#{id})"
        end

        first_name = json_person['first_name']
        middle_name = json_person['middle_name']
        last_name = json_person['last_name']

        sex = nil
        if json_person.has_key?("sex")
            sex_s = json_person['sex']
            if sex_s == 'M'
                sex = :male
            elsif sex_s == 'F'
                sex = :female
            else
                sex = :unknown
            end
        end

        bday = json_person.has_key?("birthday") ? Date.parse(json_person['birthday']) : nil
        dday = json_person.has_key?("deathday") ? Date.parse(json_person['deathday']) : nil

        alive = (dday == nil) && (json_person.has_key?("alive") ? to_bool(json_person['alive'], 'alive', json_person) : true)
        comments = json_person['comments']

        graph.add_person(GeneaPerson.new(graph, id, first_name, middle_name, last_name, sex, bday, dday, alive, comments))
    end

    def self.create_family(graph, json_object)
        type = json_object['type']

        if type == "wedding"
            type = :wedding
        elsif type == "illegitimate"
            type = :illegetimate
        end

        bdate = json_object.has_key?("begin") ? Date.parse(json_object['begin']) : nil
        edate = json_object.has_key?("end") ? Date.parse(json_object['end']) : nil

        parent1 = nil
        if json_object.has_key?("parent1")
            id = json_object['parent1']
            if not graph.has_person?(id)
                raise ArgumentError, "Cannot find first parent (#{id})"
            end
            parent1 = graph.person(id)
        end

        parent2 = nil
        if json_object.has_key?("parent2")
            id = json_object['parent2']
            if not graph.has_person?(id)
                raise ArgumentError, "Cannot find second parent (#{id})"
            end
            parent2 = graph.person(id)
        end

        issues = []
        if json_object.has_key?("issues")
            json_object['issues'].each do |id|
                if not graph.has_person?(id)
                    raise ArgumentError, "Cannot find issue (#{id})"
                end
                issues << graph.person(id) 
            end
        end

        graph.add_family(GeneaFamily.new(type, parent1, parent2, issues, bdate, edate))
    end
end
