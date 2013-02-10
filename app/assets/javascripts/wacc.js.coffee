# Determine the WACC of the business (weighted average cost of capital)
class Demo.WACC

  constructor: (statement) ->
    @statement = statement

    @cost_of_equity = statement.cost_of_equity
    unless _.isFinite( @cost_of_equity )
      @cost_of_equity = 0.30

  calculate: ->

    e = ( @statement.equity / ( @statement.debt + @statement.equity ) ) * @cost_of_equity
    d = ( @statement.debt / ( @statement.debt + @statement.equity ) ) * @statement.cost_of_debt
    t = ( 1 - @statement.tax_rate )

    e + d * t

  # Return the calculated WACC
  value: ->
    @wacc or= @calculate()

