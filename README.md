Alakazam
=========

What is
-------
Alakazam provides methods to observe all your things.

Install
-------
`$ gem install alakazam`

Examples
-------

Invoke a `block` on `#fire!` (observing an instance methods).
```ruby
require 'alakazam'

class Shiftry
  include Alakazam

  def lol
    fire!
    notify 'fired'
  end
end

shiftry = Shiftry.new
shiftry.is_observed_by { |*things|
  p things
}

shiftry.lol
```

Invoke a `block` on `#fire!` (observing a class methods).
```ruby
require 'alakazam'

class Shiftry
  extend Alakazam

  def self.lol
    fire!
    notify 'fired'
  end
end

Shiftry.is_observed_by(nil, on_change: false) { |*things|
  p things
}

Shiftry.lol
```

Invoke a `Proc` on `#fire!` (observing an instance methods).
```ruby
require 'alakazam'

class Shiftry
  include Alakazam

  def lol
    fire!
    notify 'fired'
  end
end

logger  = ->(*things) { p things }

shiftry = Shiftry.new
shiftry.is_observed_by logger

shiftry.lol
```

Invoke a `Proc` on `#fire!` (observing a class methods).
```ruby
require 'alakazam'

class Shiftry
  extend Alakazam

  def self.lol
    fire!
    notify 'fired'
  end
end

logger  = ->(*things) { p things }

Shiftry.is_observed_by logger, on_change: false

Shiftry.lol
```

Invoke a `Proc` without using `#fire!`.
```ruby
require 'alakazam'

class Shiftry
  include Alakazam

  def lol
    notify 'fired'
  end
end

logger  = ->(*things) { p things }

shiftry = Shiftry.new
shiftry.is_observed_by logger, on_change: false

shiftry.lol
```

Invoke both the default (`#update`) and a custom method of the observer class.
```ruby
require 'alakazam'

class Shiftry
  include Alakazam

  def lol
    fire!
    notify 'fired'
  end
end

class Logger
  def update(*things)
    p things
  end

  def self.on_fire(*things)
    p things
  end
end

shiftry = Shiftry.new
shiftry.is_observed_by Logger.new, methods: [ :on_fire ]
shiftry.is_observed_by Logger.new

shiftry.lol
```

Invoke `#update` when a variable changes in the observed class.
```ruby
require 'alakazam'

class Shiftry
  include Alakazam
  attr_accessor :lal

  def lol
    notify 'fired'
  end
end

class Logger
  def update(*things)
    p things
  end

  def on_fire(*things)
    p things
  end
end

shiftry = Shiftry.new
shiftry.is_observed_by Logger.new, attributes: { var: :lal, notify: 'fired' }

shiftry.lal = 3
```