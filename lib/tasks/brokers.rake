namespace :preload do
  desc 'Preload broker data'
  task :brokers => :environment do
    file = File.read(File.join(Rails.root, "public", "data", "broker.xlsx"))

    # open the speadsheet
    workbook = Roo::Spreadsheet.open(file, extension: :xlsx)

    workbook.default_sheet = 'Sheet1'
    header = spreadsheet.row(1)

    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      puts row
    end
  end
end
