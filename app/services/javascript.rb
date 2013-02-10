require 'v8'
# require 'rhino'

# This service wraps a JS context and allows us to interact with our Javascript
# directly in Ruby.
class Javascript

  # Our V8 context object
  attr_reader :context

  # Some delegations
  delegate :load, :eval, :[], :[]=, to: :context

  def initialize()
    @context = V8::Context.new
    #@context = Rhino::Context.new

    # Setup a fake 'window' object
    @context['window'] = FakeWindow.new( @context )
    @context['console'] = FakeConsole.new

    # Load our global setup
    load_coffee Rails.root.join( 'app/assets/javascripts/setup.js.coffee' )
  end

  # This class facilitates settings up a fake 'window' object in the missing dom
  # in our V8 context. Assign an instance of this class to the 'window' object
  # in the context, and any property defined on the instance will be set as a
  # global in the context...
  class FakeWindow
    # Initiate a fake window, passing a V8 context
    def initialize( context )
      @context = context
    end

    # Whatever property gets set here gets set on the provided context
    def []=( property, value )
      @context[ property ] = value
    end
  end

  class FakeConsole
    def log( *args )
      Rails.logger.info( "[V8] " + args.inspect )
      p args
    end
  end

  def fake_dom!
    # Load underscore as dependency
    if context['_'].nil?
      context.load Rails.root.join("vendor/assets/javascripts/underscore.js")
    end

    # Setup a fake setTimeout that fires immediately
    context.eval <<-EOJS
    setTimeout = function( callback, time ) {
      callback();
    }
    EOJS

    # This sets up a fake $ callback handler for our own compiled coffeescript
    # files, and pushes the handlers onto a queue for later evaluation
    context.eval <<-EOJS
    readyQ = [];
    $ = function( handler ) {
      readyQ.push( handler );
    }
    EOJS

    yield

    # Now simply trigger each handler in the queue
    context.eval <<-EOJS
    _.each( readyQ, function(handler) { handler() } );
    readyQ = [];
    EOJS

    @dom_faked = true
  end

  # Compile and load a CoffeeScript file into the current context
  def load_coffee( path )
    compiled_coffeescript = CoffeeScript.compile( File.read( path ) )
    context.eval compiled_coffeescript
  end
end

