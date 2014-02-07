#--
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

module Alakazam
  def add_observer(observer = nil, options = {}, &block)
    on_change = if options.include? :on_fire
      options[:on_fire]
    elsif options.include? :on_change
      options[:on_change]
    else
      true
    end

    attributes  = options[:attributes] || {}
    methods     = options[:methods   ] || []

    attributes = [attributes] unless attributes.is_a? Array
    methods    = [methods   ] unless methods.is_a?    Array

    attributes.each { |attribute|
      next if not attribute[:var]
      
      self.class.send(:define_method, :"#{attribute[:var]}=") do |val|
        fire!
        notify_observers attribute[:notify]
        instance_eval "@#{attribute[:var]} = #{val}"
      end
    }

    __observers__[block   ] = { on_change: on_change, methods: methods } if block_given?
    __observers__[observer] = { on_change: on_change, methods: methods } if observer
  end
    alias_method :is_observed_by, :add_observer

  def delete_observer(observer)
    __observers__.delete observer
  end
    alias_method :remove_observer, :delete_observer

  def has_observer?(observer)
    __observers__.include? observer
  end
    alias_method :is_observed_by?, :has_observer?

  def count_observers
    __observers__.length
  end
    alias_method :how_many_observers?, :count_observers

  def changed
    @changed = !changed?
  end
    alias_method :change!, :changed
    alias_method :fire!,   :changed

  def changed=(state)
    @changed = state
  end
    alias_method :fired=, :changed=

  def changed?
    !!@changed
  end
    alias_method :fired?, :changed?

  def notify_observers(*things)
    __observers__.each { |observer, options|
      if !options[:on_change] || changed?
        if options[:methods].any?
          options[:methods].each { |method|
            if observer.respond_to? method
              observer.send method, *things
            elsif observer.singleton_class.respond_to? method
              observer.singleton_class.send method, *things
            end
          }
        elsif observer.respond_to? :update
          observer.update *things
        elsif observer.is_a? Proc
          observer.call   *things
        else
          options[:methods].each { |method|
            observer.send(method, *things) if observer.respond_to? method
          }
        end
      end
    }

    @changed = false
  end
    alias_method :notify, :notify_observers
    alias_method :fire,   :notify_observers

  private
    def __observers__
      @observers ||= {}
    end
end