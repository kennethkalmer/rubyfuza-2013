class BlownController < ApplicationController
  def away
  end

  def download
    # Extract our params
    statement = ActiveSupport::JSON.decode( params[:statement] )

    # Build a download
    wacc_download = WaccDownload.new( statement )

    # Send back
    send_data wacc_download.stream, type: 'application/pdf', filename: 'WACC.pdf'
  end
end
