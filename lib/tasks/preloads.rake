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

      #p.build_property()
      #p.build_gl()
      #p.build_crime()
      #p.build_auto()

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
    end
  end

  desc 'Preload core information/data'
  task :insurance => :environment do
    file = File.read(File.join(Rails.root, "public", "data", "core.json"))
    data_hash = JSON.parse(file)

    data_hash.each do |h|
      p = Policy.find_by_policy_number(policy_number: h['1'])
      #p = Policy.create!(
      p.update(
        A: h['1'],B: h['2'],C: h['3'],D: h['4'],E: h['5'],F: h['6'],G: h['7'],H: h['8'],
        I: h['9'],J: h['10'],K: h['11'],L: h['12'],M: h['13'],N: h['14'],O: h['15'],
        P: h['16'],Q: h['17'],R: h['18'],S: h['19'],T: h['20'],U: h['21'],V: h['22'],
        W: h['23'],X: h['24'],Y: h['25'],Z: h['26'],AA: h['27'],AB: h['28'],
        AC: h['29'],AD: h['30'],AE: h['31'],AF: h['32'],AG: h['33'],AH: h['34'],
        AI: h['35'],AJ: h['36'],AK: h['37'],AL: h['38'],AM: h['39'],AN: h['40'],
        AO: h['41'],AP: h['42'],AQ: h['43'],AR: h['44'],AS: h['45'],AT: h['46'],
        AU: h['47'],AV: h['48'],AW: h['49'],AX: h['50'],AY: h['51'],AZ: h['52'],
        BA: h['53'],BB: h['54'],BC: h['55'],BD: h['56'],BE: h['57'],BF: h['58'],
        BG: h['59'],BH: h['60'],BI: h['61'],BJ: h['62'],BK: h['63'],BL: h['64'],
        BM: h['65'],BN: h['66'],BO: h['67'],BP: h['68'],BQ: h['69'],BR: h['70'],
        BS: h['71'],BT: h['72'],BU: h['73'],BV: h['74'],BW: h['75'],BX: h['76'],
        BY: h['77'],BZ: h['78'],CA: h['79'],CB: h['80'],CC: h['81'],CD: h['82'],
        CE: h['83'],CF: h['84'],CG: h['85'],CH: h['86'],CI: h['87'],CJ: h['88'],
        CK: h['89'],CL: h['90'],CM: h['91'],CN: h['92'],CO: h['93'],CP: h['94'],
        CQ: h['95'],CR: h['96'],CS: h['97'],CT: h['98'],CU: h['99'],CV: h['100'],
        CW: h['101'],CX: h['102'],CY: h['103'],CZ: h['104'],DA: h['105'],DB: h['106'],
        DC: h['107'],DD: h['108'],DE: h['109'],DF: h['110'],DG: h['111'],DH: h['112'],
        DI: h['113'],DJ: h['114'],DK: h['115'],DL: h['116'],DM: h['117'],DN: h['118'],
        DO: h['119'],DP: h['120'],DQ: h['121'],DR: h['122'],DS: h['123'],DT: h['124'],
        DU: h['125'],DV: h['126'],DW: h['127'],DX: h['128'],DY: h['129'],DZ: h['130'],
        EA: h['131'],EB: h['132'],EC: h['133'],ED: h['134'],EE: h['135'],EF: h['136'],
        EG: h['137'],EH: h['138'],EI: h['139'],EJ: h['140'],EK: h['141'],EL: h['142'],
        EM: h['143'],EN: h['144'],EO: h['145'],EP: h['146'],EQ: h['147'],ER: h['148'],
        ES: h['149'],ET: h['150']
      )
    end
  end
end
