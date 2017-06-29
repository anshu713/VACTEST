module Rms::Reports
  class FTE
    attr_reader :filename, :filetype

    # Creates a new FTE Report Object
    def initialize
      @empftes = Bvadmin::Employee.emp_fte_report
      @cur_pp = Bvadmin::Payperiod.cur_pp.first
      @next_pp = Bvadmin::Payperiod.next_pp.first
      @fte_losses = Bvadmin::Employee.fte_losses(@cur_pp.startdate, @cur_pp.startdate)
      @fte_new_hires = Bvadmin::EmployeeApplicant.fte_new_hires(@next_pp.startdate, @next_pp.enddate)

      @payperiod = @cur_pp.payperiod
      @pp_enddate = @cur_pp.enddate.strftime("%m/%d/%Y")
      @eod_date = @next_pp.startdate.next_week(:monday).strftime("%m/%d/%Y")
      @loss_date = (@cur_pp.enddate + 1.weeks).strftime("%m/%d/%Y")
      @fte_total = @empftes.sum(:fte)
      @fte_ao_total = @fte_total + @fte_new_hires.count - @fte_losses.count
      @board_total = @empftes.count + @fte_new_hires.count - @fte_losses.count

      @report = nil
      @filename = 'invalid-report.txt'
      @filetype = 'text/plain'
    end

    # Generates an FTE report in XLS format.
    # Returns the binary XLS document.
    def xls
      header = [ "PP #{@payperiod}", '', "Pay Period #{@payperiod} Ended #{@pp_enddate}" ]

      @report = Rms::Export::XLSSpreadsheet.new('Latest FTE Report', header)
      @filename = "fte-report-pp#{@payperiod}-#{@cur_pp.startdate.strftime('%Y-%m-%d')}-#{@cur_pp.enddate.strftime('%Y-%m-%d')}.xls"
      @filetype = 'application/vnd.ms-excel'

      @report.add_entry [ 'GD', 'ST', 'NAME', 'HRS', 'FTEE' ], @report.format.bold
      if @empftes.empty?
        @report.add_entry [ '', '', 'NONE' ]
      else
        @empftes.each_with_index do |emp, idx|
          @report.add_entry [ emp.grade, emp.step, emp.name, emp.fte*80, emp.fte, idx+1 ]
        end
      end

      @report.add_blank
      @report.add_entry [ '', '', '', 'FTE', @fte_total ], @report.format.bold

      @report.add_blank
      @report.add_entry [ '', '', "New Hires Added PP #{@payperiod+1} EOD #{@eod_date}" ], @report.format.bold

      if @fte_new_hires.empty?
        @report.add_entry [ '', '', 'NONE' ]
      else
        @fte_new_hires.each do |emp|
          @report.add_entry [ emp.grade, emp.step, emp.name, 80, 1 ]
        end
      end

      @report.add_blank
      @report.add_entry [ '', '', "Losses Subtracted PP #{@payperiod} a/o #{@loss_date}" ], @report.format.bold

      if @fte_losses.empty?
        @report.add_entry [ '', '', 'NONE' ]
      else
        @fte_losses.each do |emp|
          @report.add_entry [ emp.grade, emp.step, emp.name, 80, 1 ]
        end
      end
      
      @report.add_blank
      @report.add_entry [ '', '', "TOTAL FTE A/O #{@loss_date}", '', @fte_ao_total ]
      @report.format_entry [2,3,4], @report.format.highlight

      @report.add_blank 2
      @report.add_entry [ '', '', "Total Employees on board as of #{@loss_date}", '', @board_total ]
      @report.format_entry [2,3,4], @report.format.highlight

      @report.process.string
    end

    # Generates an FTE report in PDF format.
    # Returns the binary PDF document.
    def pdf
    end
  end
end
