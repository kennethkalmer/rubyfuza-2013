class WaccLayout

  def initialize( view, context = Javascript.new )
    @context = context

    load_dependencies

    # Pass our Ruby view into the context
    @context["view"] = view

    # Setup
    @context.eval <<-EOJS
    var layout = new Demo.WaccLayout( statement, view );
    EOJS
  end

  def render
    @context['layout']['render'].methodcall( @context['layout'] )
  end

  def load_dependencies
    @context.load Rails.root.join("vendor/assets/javascripts/underscore.js")

    @context.load_coffee Rails.root.join("app/assets/javascripts/wacc.js.coffee")
    @context.load_coffee Rails.root.join("app/assets/javascripts/wacc_layout.js.coffee")
  end
end
