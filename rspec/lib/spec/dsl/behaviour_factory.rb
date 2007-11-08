module Spec
  module DSL
    class BehaviourFactory
      class << self
        def reset!
          @behaviour_types = {
            :default => Spec::DSL::Example,
            :shared => Spec::DSL::SharedBehaviour
          }      
        end

        # Registers a behaviour class +klass+ with the symbol
        # +type+. For example:
        #
        #   Spec::DSL::BehaviourFactory.register(:farm, Spec::Farm::DSL::FarmBehaviour)
        #
        # This will cause Main#describe from a file living in 
        # <tt>spec/farm</tt> to create behaviour instances of type
        # Spec::Farm::DSL::FarmBehaviour.
        def register(id, behaviour)
          @behaviour_types[id] = behaviour
        end

        def get(id=:default)
          id ||= :default
          if @behaviour_types.values.include?(id)
            return id
          else
            behaviour = @behaviour_types[id]
            return behaviour
          end
        end
        
        def get!(id=:default)
          behaviour = get(id)
          unless behaviour
            raise "Behaviour #{id.inspect} is not registered. Use ::Spec::DSL::BehaviourFactory.register"
          end
          return behaviour
        end  

        def create_behaviour_class(*args, &block)
          opts = Hash === args.last ? args.last : {}
          if opts[:shared]
            id = :shared
            return create_shared_module(*args, &block)
            
          # new: replaces behaviour_type  
          elsif opts[:type]
            id = opts[:type]
            
          #backwards compatibility
          elsif opts[:behaviour_type]
            id = opts[:behaviour_type]
            
          elsif opts[:spec_path] =~ /spec(\\|\/)(#{@behaviour_types.keys.join('|')})/
            id = $2.to_sym
          else
            id = :default
          end
          example_class = Class.new(get(id))
          example_class.describe(*args, &block)
          example_class
        end

        protected
        def create_shared_module(*args, &block)
          @behaviour_types[:shared].new(*args, &block)
        end
      end
      self.reset!
    end
  end
end