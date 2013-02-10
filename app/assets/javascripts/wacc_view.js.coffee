# Simple backbone view
class Demo.WaccView extends Backbone.View

  render: (options) ->
    wacc = _.str.sprintf "%.2f", options.wacc * 100
    @$('span.wacc').text( "#{wacc}%" )

    @$el.show()
