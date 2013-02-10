class Demo.WaccLayout

  # The view that will render our information
  view: null

  constructor: (@statement, @view = null) ->

  render: ->
    wacc = new Demo.WACC( @statement )

    @view.render( statement: @statement, wacc: wacc.value() )
