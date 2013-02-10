# Brings together the user input and generates a PDF for download
class WaccDownload

  def initialize( params )
    @params = params
  end

  # Generate the PDF and stream it back
  def stream
    render_layout

    pdf_content
  end

  private

  def render_layout
    # Setup a JS context
    js = Javascript.new

    # Set our parameters in the context
    js.eval <<-EOJS
    var statement = {
      equity: #{@params['equity']},
      debt: #{@params['debt']},
      cost_of_equity: #{@params['cost_of_equity']},
      cost_of_debt: #{@params['cost_of_debt']},
      tax_rate: #{@params['tax_rate']}
    };
    EOJS

    # Setup our view
    @view = WaccPdf.new

    # Setup a layout
    @layout = WaccLayout.new( @view, js )
    @layout.render
  end

  def pdf_content
    @view.pdf_content
  end

end
