class WaccPdf

  include ActionView::Helpers::NumberHelper

  def initialize
    @pdf = Prawn::Document.new
  end

  def render( options )
    wacc = options.wacc * 100

    @pdf.text "Weighted Average Cost of Capital", style: :bold, align: :center
    @pdf.text number_to_percentage( wacc, precision: 2 ), align: :center

    @pdf.move_down 12
    @pdf.text "Statement inputs", style: :bold, align: :center

    coe = options.statement.cost_of_equity * 100
    cod = options.statement.cost_of_debt * 100
    tax = options.statement.tax_rate * 100

    data = [
      [ 'Equity', options.statement.equity ],
      [ 'Debt', options.statement.debt ],
      [ 'Cost of Equity', number_to_percentage( coe, precision: 2 ) ],
      [ 'Cost of Debt', number_to_percentage( cod, precision: 2 ) ],
      [ 'Tax rate', number_to_percentage( tax, precision: 2 ) ]
    ]
    @pdf.table( data, width: @pdf.bounds.width )
  end

  def pdf_content
    @pdf.render
  end

end
