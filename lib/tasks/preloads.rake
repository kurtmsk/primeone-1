require 'action_view'


namespace :preload do
  desc 'Preload broker data'
  task :brokers => :environment do
    include ActionView::Helpers::NumberHelper
    # open the speadsheet
    workbook = Roo::Spreadsheet.open('public/data/brokers.xlsx', extension: :xlsx)

    workbook.default_sheet = 'Sheet1'

    (2..workbook.last_row).each do |i|
      Broker.create!( name: (workbook.row(i)[0] || ""), dba: (workbook.row(i)[1] || ""),
      street: (workbook.row(i)[2] || ""), city: (workbook.row(i)[3] || ""),
      state: (workbook.row(i)[4] || ""), zip: (workbook.row(i)[5].to_s.split('.')[0] || ""),
      phone: (number_to_phone(workbook.row(i)[6].to_s.split('.')[0], area_code:true) || ""),
      email: (workbook.row(i)[7] || ""), contact_name: (workbook.row(i)[8] || ""),
      commission: ((workbook.row(i)[9] || 0)*100).to_i, agreement_sent: (workbook.row(i)[10] || ""),
      agreement_completed: (workbook.row(i)[11] || ""), pac_risk_fee_schedule: ((workbook.row(i)[12] || 0)*100).to_i,
      notes: (workbook.row(i)[13] || ""), target_premium: (workbook.row(i)[14] || "") )
    end
  end

  desc 'Preload policy container'
  task :policies => :environment do
    # open the speadsheet
    workbook = Roo::Spreadsheet.open('public/data/policies.xlsx', extension: :xlsx)

    workbook.default_sheet = 'Sheet1'

    (2..workbook.last_row).each do |i|
      p = Policy.new( status: (workbook.row(i)[0] || ""), client_code: (workbook.row(i)[1] || ""),
        name: (workbook.row(i)[2] || ""), effective_date: (workbook.row(i)[3] || ""),
        policy_number: (workbook.row(i)[4] || "") )

      p.build_property()
      p.build_gl()
      p.build_crime()
      p.build_auto()

      p.save

      # add all documents
      p.docs.create!({
        form_code:"CP0440(6/95)",	file:"CP0440.html",
        description:"SPOILAGE COVERAGE", var_1: p.policy_number,
        var_6: nil
      })
      p.docs.create!({
        form_code:"CP1218(6/95)",	file:"CP1218.html",
        description:"LOSS PAYABLE PROVISIONS", var_1: p.policy_number
      })
      p.docs.create!({
        form_code:"IL0415(04/98)",	file:"IL0415.html",
        description:"PROTECTIVE SAFEGUARDS", var_1: p.policy_number,
        var_5: nil, var_6: nil
      })
      p.docs.create!({
        form_code:"CG2144(7/98)",	file:"CG2144.html",
        description:"LIMITATION OF COVERAGE/DESIGNATED PREMISES", var_1: p.policy_number,
        var_4: nil, var_5: nil, var_6: nil
      })
      p.docs.create!({
        form_code:"CG2011(1/96)",	file:"CG2011.html",
        description:"ADD'L INSURED MANAGERS/LESSORS", var_1: p.policy_number,
        var_5: nil, var_6: nil
      })
      p.docs.create!({
        form_code:"CG2018(11/85)",	file:"CG2018.html",
        description:"ADD'L INSURED MORTGAGEE, ETC.", var_1: p.policy_number,
        var_4: nil, var_5: nil, var_6: nil
      })
      p.docs.create!({
        form_code:"CG2026(7/04)",	file:"CG2026.html",
        description:"ADD'L INSURED DESIGNATED PERSON", var_1: p.policy_number,
        var_5: nil, var_6: nil
      })
      p.docs.create!({
        form_code:"CG2028(7/04)",	file:"CG2028.html",
        description:"ADD'L INSURED LESSOR OF LEASED EQUIPMENT", var_1: p.policy_number,
        var_3: nil, var_4: nil, var_5: nil, var_6: nil
      })

      #puts fields
    end
  end

  desc 'Preload policy information/data'
  task :data => :environment do
    file = File.read(File.join(Rails.root, "public", "data", "policies.json"))
    data_hash = JSON.parse(file)

    data_hash.each do |h|
      p = Policy.create!()
    end
  end
end
