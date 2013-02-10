#= require bootstrap-tooltip

class Demo.App extends Backbone.View

  events:
    'click .display': 'display'
    'click .download': 'download'

  display: (event) ->
    event.preventDefault()

    # Setup a view
    view = new Demo.WaccView( el: '#wacc' )

    # Setup a layout and render the results
    layout = new Demo.WaccLayout( @statement(), view )
    layout.render()

    false

  download: (event) ->
    @$('input[name=statement]').val JSON.stringify( @statement() )

    true

  statement: ->
    # Build a statement
    statement =
      equity: @val('equity')
      debt: @val('debt')
      cost_of_equity: @percentage('coe')
      cost_of_debt: @percentage('cod')
      tax_rate: @percentage('tax')

  val: (field) ->
    parseFloat @$("input[name=#{field}]").val()

  percentage: (field) ->
    @val( field ) / 100

$ ->

  # Setup our view on page load
  new Demo.App( el: '#statement' )

  # Setup tooltips to help
  $('input[type=text]').tooltip( placement: 'right' )
