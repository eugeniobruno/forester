module Forester
  module Validators

    def validate_uniqueness_of_field(field, options = {})
      validate_uniqueness_of_fields([field], options)
    end

    def validate_uniqueness_of_fields(fields, options = {})
      default_options = {
        combination:              false,
        first_failure_only:       false,
        within_subtrees_of_level: 0,
        among_siblings_of_level:  :not_siblings,
        field_for_failures:       :name,
        as_failure: ->(node) { node.get(options[:field_for_failures]) }
      }
      options = default_options.merge(options)

      return of_combination_of_fields(fields, options) if options[:combination]

      failures = Hash.new(Hash.new([]))

      nodes_of_level(options[:within_subtrees_of_level]).each do |subtree|
        visited_nodes = []
        nodes_to_visit =
          if options[:among_siblings_of_level] == :not_siblings
            subtree.each_node
          else
            nodes_of_level(options[:among_siblings_of_level])
          end

        nodes_to_visit.each  do |node|
          visited_nodes.each do |vn|
            fields.each      do |field|
              next unless all_have?(field, [vn, node])

              if same_values?(field, [vn, node])
                k = vn.get(field) # repeated value

                prepare_hash(failures, field, k)

                add_failure_if_new(failures, field, k, options[:as_failure].call(vn))
                add_failure(       failures, field, k, options[:as_failure].call(node))

                return result(failures) if options[:first_failure_only]
              end
            end
          end
          visited_nodes << node
        end
      end

      result(failures)
    end

    private

    def of_combination_of_fields(fields, options)
      failures = Hash.new(Hash.new([]))

      nodes_of_level(options[:within_subtrees_of_level]).each do |subtree|
        visited_nodes = []
        nodes_to_visit =
          if options[:among_siblings_of_level] == :not_siblings
            subtree.each_node
          else
            nodes_of_level(options[:among_siblings_of_level])
          end

        nodes_to_visit.each  do |node|
          visited_nodes.each do |vn|
            next unless all_have_all?(fields, [vn, node])

            if same_values_for_all?(fields, [vn, node])
              k = fields.map { |f| vn.get(f) } # repeated combination of values

              prepare_hash(failures, fields, k)

              add_failure_if_new(failures, fields, k, options[:as_failure].call(vn))
              add_failure(       failures, fields, k, options[:as_failure].call(node))

              return result(failures) if options[:first_failure_only]
            end
          end
          visited_nodes << node
        end
      end

      result(failures)
    end

    private

    def all_have?(field, nodes)
      all_have_all?([field], nodes)
    end

    def all_have_all?(fields, nodes)
      nodes.all? { |n| fields.all? { |f| n.has?(f) } }
    end

    def same_values?(field, nodes)
      same_values_for_all?([field], nodes)
    end

    def same_values_for_all?(fields, nodes)
      fields
        .map  { |f| nodes.map { |n| n.get(f) } }
        .all? { |vs| vs.uniq.length <= 1 }
    end

    def prepare_hash(hash, key, subkey)
      hash[key]         = {} unless hash.has_key?(key)
      hash[key][subkey] = [] unless hash[key].has_key?(subkey)
    end

    def add_failure_if_new(failures, key, subkey, value)
      add_failure(failures, key, subkey, value) unless failures[key][subkey].include?(value)
    end

    def add_failure(failures, key, subkey, value)
      failures[key][subkey] << value
    end

    def result(failures)
      {
        is_valid: failures.empty?,
        repeated: failures.each_with_object({}) { |(k,v), h| h[k] = v.keys },
        failures: failures
      }
    end

  end
end
