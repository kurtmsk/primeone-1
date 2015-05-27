require 'action_view'


namespace :preload do
  desc 'Preload broker data'
  task :brokers => :environment do
    include ActionView::Helpers::NumberHelper
    # open the speadsheet
    workbook = Roo::Spreadsheet.open('public/data/brokers.xlsx', extension: :xlsx)

    workbook.default_sheet = 'Sheet1'

    (2..workbook.last_row).each do |i|
      Broker.create( name: (workbook.row(i)[0] || ""), dba: (workbook.row(i)[1] || ""),
      street: (workbook.row(i)[2] || ""), city: (workbook.row(i)[3] || ""),
      state: (workbook.row(i)[4] || ""), zip: (workbook.row(i)[5].to_s.split('.')[0] || ""),
      phone: (number_to_phone(workbook.row(i)[6].to_s.split('.')[0], area_code:true) || ""),
      email: (workbook.row(i)[7] || ""), contact_name: (workbook.row(i)[8] || ""),
      commission: ((workbook.row(i)[9] || 0)*100).to_i, agreement_sent: (workbook.row(i)[10] || ""),
      agreement_completed: (workbook.row(i)[11] || ""), pac_risk_fee_schedule: ((workbook.row(i)[12] || 0)*100).to_i,
      notes: (workbook.row(i)[13] || ""), target_premium: (workbook.row(i)[14] || "") )
    end
  end

  desc 'Preload policy data'
  task :policies => :environment do
    # open the speadsheet
    workbook = Roo::Spreadsheet.open('public/data/policies.xlsx', extension: :xlsx)

    workbook.default_sheet = 'Sheet1'

    (2..workbook.last_row).each do |i|
      Policy.create( status: (workbook.row(i)[0] || ""), client_code: (workbook.row(i)[1] || ""),
        name: (workbook.row(i)[2] || ""), effective_date: (workbook.row(i)[3] || ""),
        policy_number: (workbook.row(i)[4] || "") )

      #puts fields
    end
  end
end
