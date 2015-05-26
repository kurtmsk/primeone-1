class PoliciesController < ApplicationController
  before_action :set_policy, only: [:show, :edit, :update, :destroy, :pdf]

  # GET /policies
  # GET /policies.json
  def index
    @policies = Policy.all
  end

  # GET /policies/1
  # GET /policies/1.json
  def show
    @title = @policy.policy_number

    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "Policy_#{@policy.policy_number}", :layout => 'pdf.html.erb'
      end
      format.json
    end
  end

  # determine which forms should be downloaded
  # POST /policies/1/forms
  def forms
    policy = Policy.find(params[:id])

    @pdfForms = CombinePDF.new
    @pdfForms << CombinePDF.new('app/assets/forms/package/all_forms.pdf')

    form_groups = [:property_forms, :gl_forms, :crime_forms, :auto_forms]

    form_groups.each do |fg|
      if !policy[fg].empty?
        policy[fg].split(" ").each do |f|
          f = f.gsub("/", "-")
          begin
            @pdfForms << CombinePDF.new("app/assets/forms/#{fg.to_s}/#{f}.pdf")
          rescue
            #begin
              #@pdfForms << CombinePDF.new("app/assets/forms/property/#{f}.doc")
            #rescue
            #end
          end
        end
      end
    end

    send_data @pdfForms.to_pdf, filename: "Forms_#{policy.policy_number}.pdf", format: 'pdf'
  end

  # GET /policies/new
  def new
    @policy = Policy.new
  end

  # GET /policies/1/edit
  def edit
  end

  # POST /policies
  # POST /policies.json
  def create
    @policy = Policy.new(policy_params)

    #uploaded_io = params[:policy][:upload]
    # temporarily save sheet
    #tmp_path = Rails.root.join('tmp', 'spreadsheets', "temp_excel"+File.extname(uploaded_io.original_filename))
    #File.open(tmp_path, 'wb') do |file|
      #file.write(uploaded_io.read)
    #end

    readWorkbook()

    findForms()

    respond_to do |format|
      if @policy.save
        format.html { redirect_to @policy, notice: 'Policy was successfully created.' }
        format.json { render :show, status: :created, location: @policy }
      else
        format.html { render :new }
        format.json { render json: @policy.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /policies/1
  # PATCH/PUT /policies/1.json
  def update
    respond_to do |format|
      if @policy.update(policy_params)
        format.html { redirect_to @policy, notice: 'Policy was successfully updated.' }
        format.json { render :show, status: :ok, location: @policy }
      else
        format.html { render :edit }
        format.json { render json: @policy.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /policies/1
  # DELETE /policies/1.json
  def destroy
    @policy.destroy
    respond_to do |format|
      format.html { redirect_to policies_url, notice: 'Policy was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_policy
      @policy = Policy.find(params[:id])
      @broker = @policy.broker
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def policy_params
      policy_params = [:policy_number, :client_code, :effective_date, :expiration_date]

      # hash params
      if !@policy.nil?
        policy_params += @policy.insured.keys.map{|x| "data__insured__#{x.to_s}".to_sym }
        policy_params += [:data__insured__type_insured]
        policy_params += @policy.mailing_address.keys.map{|x| "data__mailing_address__#{x.to_s}".to_sym }
        policy_params += @policy.agency.keys.map{|x| "data__agency__#{x.to_s}".to_sym }
        policy_params += @policy.general_liability.keys.map{|x| "data__general_liability__#{x.to_s}".to_sym }
      end

      params.require(:policy).permit(policy_params)
    end

    # Find the forms necessary for this policy
    def findForms
      # initialize forms for first page (of mandatory forms)
      @policy.forms = "IL0003(9/08) IL0017(11/98) IL0286(9/08) IL0030(1/06) IL0031(1/06)"

      # add relevant commercial property declarations
      if (@policy.property[:premium_property_total] != 0)
        # mandatory forms
        @policy.property_forms = "CP0010(6/07) CP0090(7/88) CP0120(1/08) CP0140(7/06) CP1032(8/08) IL0935(7/02) IL0953(1/08) CP1270(9/96) "
        # optional forms
        # BUSINESS INCOME & EXTRA EXPENSE
        if (!@policy.property[:locations][:location_1][:exposures][:earnings][:limit].nil? && @policy.property[:locations][:location_1][:exposures][:earnings][:limit] != 0)
          @policy.property_forms += "CP0030(6/07) "
        end
        # SPOILAGE COVERAGE **
        if (!@policy.property[:locations][:location_1][:building_exposure][:coverage_type] == "Special")
          @policy.property_forms += "CP1030(6/07) "
        end
        # SPECIAL FORM - CAUSE OF LOSS
        if (!@policy.property[:locations][:location_1][:exposures][:pumps][:limit].nil? && @policy.property[:locations][:location_1][:exposures][:pumps][:limit] != 0)
          @policy.property_forms += "CP0440(6/95) "
        end
        # OUTDOOR SIGN
        if (!@policy.property[:locations][:location_1][:exposures][:sign][:limit].nil? && @policy.property[:locations][:location_1][:exposures][:sign][:limit] != 0)
          @policy.property_forms += "CP1440(6/07) "
        end
        # ELITE PROPERTY ENHANCEMENT
        if (@policy.property[:locations][:location_1][:property_enhancement][:facticity] == "Elite")
          @policy.property_forms += "PO-PRP-3(12/13) "
        end
        # MANDATORY EQUIPMENT BREAKDOWN PROTECTION COVERAGE & MICHIGAN CHANGES
        if (@policy.property[:locations][:location_1][:mechanical_breakdown][:facticity] == "Yes")
          @policy.property_forms += "EB0020(08/08) EB0108(09/07)"
        end
      end

      # add relevant general liability declarations
      if (@policy.general_liability[:total_gl_premium] != 0)
        # mandatory forms
        @policy.gl_forms = "CG0001(12/07) CG0068(5/09) CG0099(11/85) CG0168(12/4) CG2101(11/85) CG2146(7/98) CG2147(12/07) CG2149(9/99) CG2167(12/04) CG2175(6/08) CG2190(1/06) CG2231(7/98) CG2258(11/85) CG2407(1/96) IL0021(9/08) PO-GL-5(5/12) PO-GL-6(5/12) "
        # optional forms
        # EXCLUSION MEDICAL PAYMENTS
        if (!@policy.general_liability[:limits][:medical_expense].nil? && @policy.general_liability[:limits][:medical_expense] != 0)
          @policy.gl_forms += "CG2135(10/01) "
        end
        # EXCLUSION PERSONAL INJURY
        if (!@policy.general_liability[:limits][:personal_advertising_injury].nil? && @policy.general_liability[:limits][:personal_advertising_injury] != 0)
          @policy.gl_forms += "CG2138(11/85) "
        end
        # EXCLUSION DAMAGE TO PREMISES RENTED
        if (!@policy.general_liability[:limits][:fire_damage].nil? && @policy.general_liability[:limits][:fire_damage] != 0)
          @policy.gl_forms += "CG2145(7/98) "
        end
        # WATER IN THE GAS TANK
        if (!@policy.general_liability[:water_gas_tank] == "Yes")
          @policy.gl_forms += "PO_GL_WIG(12/13)"
        end
      end

      # add relevant crime declarations
      if (@policy.crime[:crime_total_premium] != 0)
        # mandatory forms
        @policy.crime_forms = "CR0021(5/06) CR0110(8/07) CR0246(8/07) CR0730(3/06) CR0731(3/06) IL0935(7/02) IL0953(1/08) "
        # optional forms
        # EMPLOYEE THEFT AND FORGERY POLICY
        if ((!@policy.crime[:employee_theft][:limit].nil? && @policy.crime[:employee_theft][:limit] != 0) ||
          (!@policy.crime[:forgery_alteration][:limit].nil? && @policy.crime[:forgery_alteration][:limit] != 0))
          @policy.crime_forms += "CR0029(5/06) "
        end
        # INSIDE THE PREMISES-THEFT OF OTHER PROPERTY
        if (!@policy.crime[:premises][:limit].nil? && @policy.crime[:premises][:limit] != 0)
          @policy.crime_forms += "CR0405(8/07) "
        end
        # INSIDE THE PREMISES – ROBBERY OF A CUSTODIAN OR SAFE BURGLARY OF MONEY & SECURITIES
        if ((!@policy.crime[:money_securities][:limit].nil? && @policy.crime[:money_securities][:limit] != 0) ||
          (!@policy.crime[:safe_burglary][:limit].nil? && @policy.crime[:safe_burglary][:limit] != 0))
          @policy.crime_forms += "CR0405(8/07) "
        end
      end

      # add relevant commerical auto declarations
      if (@policy.commercial_auto[:total_auto_premium] != "0.00")
        # mandatory forms
        @policy.auto_forms = "CA0110(11/06) CA0217(3/94) CA0001(3/06) CA2384(1/06) PO-CA-1(5/12) "
      end

    end

    # Read the workbook to fill out the policy
    def readWorkbook
      # open the speadsheet
      workbook = Roo::Spreadsheet.open(params[:policy][:upload], extension: :xlsx)

      workbook.default_sheet = 'Rating'

      @policy.insured = { name: workbook.cell('C',3), quoted_by: workbook.cell('B',1),
        date: workbook.cell('B',2), dba: workbook.cell('B',4),
        type_business: workbook.cell('L',5), mortgagee: workbook.cell('S',3) }

      @policy.mailing_address = { street: workbook.cell('C',5), city: workbook.cell('B',6),
        state: workbook.cell('G',6), zip: workbook.cell('K',6).to_s }

      @policy.agency = { contact: workbook.cell('L',1), name: workbook.cell('L',2),
         email: workbook.cell('K',3) }

      @policy.property = {
        locations: {
          location_1: { co_insurance: workbook.cell('L',14), co_insurance_factor: workbook.cell('L',15),
            deductible: workbook.cell('B',15), deductible_factor: workbook.cell('G',15),

            address: { street: workbook.cell('C',10), city: workbook.cell('B',11),
              state: workbook.cell('G',11), zip: workbook.cell('K',11).to_s },

            building_exposure: { type_of_business: workbook.cell('L',10),
              coverage_type: workbook.cell('D',12), protection_class: workbook.cell('L',12),
              updates: workbook.cell('K',13), year_built: workbook.cell('B',13),
              construction_type: workbook.cell('H',13), number_stories: workbook.cell('E',13),
              square_feet: workbook.cell('B',14), parking_lot_square_feet: workbook.cell('H',14) },

            food_spoilage: { facticity: workbook.cell('F',17).empty?, limit: workbook.cell('F',17),
              rate: workbook.cell('H',17), premium: workbook.cell('J',17) },

            theft: { facticity: workbook.cell('D',18), limit: workbook.cell('F',18),
              rate: workbook.cell('H',18), premium: workbook.cell('J',18) },

            property_enhancement: { facticity: workbook.cell('D',19), limit: workbook.cell('F',19),
              rate: workbook.cell('H',19), premium: workbook.cell('J',19) },

            mechanical_breakdown: { facticity: workbook.cell('D',20), limit: workbook.cell('F',20),
              rate: workbook.cell('H',20), premium: workbook.cell('J',20) },
            exposures: {
              building: { name: workbook.cell('A',23), valuation: workbook.cell('D',23),
                limit: workbook.cell('F',23), rate: workbook.cell('H',23),
                ded_factor: workbook.cell('J',23), co_ins_factor: workbook.cell('L',23),
                premium: workbook.cell('O',23) },

              bpp:{ name: workbook.cell('A',24), valuation: workbook.cell('D',24),
                limit: workbook.cell('F',24), rate: workbook.cell('H',24),
                ded_factor: workbook.cell('J',24), co_ins_factor: workbook.cell('L',24),
                premium: workbook.cell('O',24) },

              earnings: { name: workbook.cell('A',25), valuation: workbook.cell('D',25),
                limit: workbook.cell('F',25), rate: workbook.cell('H',25),
                ded_factor: workbook.cell('J',25), co_ins_factor: workbook.cell('L',25),
                premium: workbook.cell('O',25) },

              sign: { name: workbook.cell('A',26), valuation: workbook.cell('D',26),
                limit: workbook.cell('F',26), rate: workbook.cell('H',26),
                ded_factor: workbook.cell('J',26), co_ins_factor: workbook.cell('L',26),
                premium: workbook.cell('O',26) },

              pumps: { name: workbook.cell('A',27), valuation: workbook.cell('D',27),
                limit: workbook.cell('F',27), rate: workbook.cell('H',27),
                ded_factor: workbook.cell('J',27), co_ins_factor: workbook.cell('L',27),
                premium: workbook.cell('O',27) },

              canopies: { name: workbook.cell('A',28), valuation: workbook.cell('D',28),
                limit: workbook.cell('F',28), rate: workbook.cell('H',28),
                ded_factor: workbook.cell('J',28), co_ins_factor: workbook.cell('L',28),
                premium: workbook.cell('O',28) },

              other: { name: workbook.cell('B',29), valuation: workbook.cell('D',29),
                limit: workbook.cell('F',29), rate: workbook.cell('H',29),
                ded_factor: workbook.cell('J',29), co_ins_factor: workbook.cell('L',29),
                premium: workbook.cell('O',29) } },

            location_1_property_premium: workbook.cell('N',33) } },
        property_schedule_rating_pct: workbook.cell('J',36),
        property_subtotal: workbook.cell('J',35), property_premium_total: workbook.cell('M',41) }

        if (workbook.cell('T',10) != nil)
          @policy.property[:locations][:location_2] = { co_insurance: workbook.cell('AC',12),
            co_insurance_factor: workbook.cell('AC',15),
            deductible: workbook.cell('S',15), deductible_factor: workbook.cell('X',15),

            address: { street: workbook.cell('T',10), city: workbook.cell('S',11),
              state: workbook.cell('X',11), zip: workbook.cell('AB',11).to_s },

            building_exposure: { type_of_business: workbook.cell('AC',10),
              coverage_type: workbook.cell('U',12), protection_class: workbook.cell('AC',12),
              updates: workbook.cell('AB',13), year_built: workbook.cell('S',13),
              construction_type: workbook.cell('Y',13), number_stories: workbook.cell('V',13),
              square_feet: workbook.cell('S',14), parking_lot_square_feet: workbook.cell('Y',14) },

            food_spoilage: { facticity: workbook.cell('W',17).empty?, limit: workbook.cell('W',17),
              rate: workbook.cell('Y',17), premium: workbook.cell('AA',17) },

            theft: { facticity: workbook.cell('U',18), limit: workbook.cell('W',18),
              rate: workbook.cell('Y',18), premium: workbook.cell('AA',18) },

            property_enhancement: { facticity: workbook.cell('U',19), limit: workbook.cell('W',19),
              rate: workbook.cell('Y',19), premium: workbook.cell('AA',19) },

            mechanical_breakdown: { facticity: workbook.cell('U',20), limit: workbook.cell('W',20),
              rate: workbook.cell('Y',20), premium: workbook.cell('AA',20) },
            exposures: {
              building: { valuation: workbook.cell('U',23), limit: workbook.cell('W',23),
                rate: workbook.cell('Y',23), ded_factor: workbook.cell('AA',23),
                co_ins_factor: workbook.cell('AC',23), premium: workbook.cell('AF',23) },

              bpp:{ valuation: workbook.cell('U',24), limit: workbook.cell('W',24),
                rate: workbook.cell('Y',24), ded_factor: workbook.cell('AA',24),
                co_ins_factor: workbook.cell('AC',24), premium: workbook.cell('AF',24) },

              earnings: { valuation: workbook.cell('U',25), limit: workbook.cell('W',25),
                rate: workbook.cell('Y',25), ded_factor: workbook.cell('AA',25),
                co_ins_factor: workbook.cell('AC',25), premium: workbook.cell('AF',25) },

              sign: { valuation: workbook.cell('U',26), limit: workbook.cell('W',26),
                rate: workbook.cell('Y',26), ded_factor: workbook.cell('AA',26),
                co_ins_factor: workbook.cell('AC',26), premium: workbook.cell('AF',26) },

              pumps: { valuation: workbook.cell('U',27), limit: workbook.cell('W',27),
                rate: workbook.cell('Y',27), ded_factor: workbook.cell('AA',27),
                co_ins_factor: workbook.cell('AC',27), premium: workbook.cell('AF',27) },

              canopies: { valuation: workbook.cell('U',28), limit: workbook.cell('W',28),
                rate: workbook.cell('Y',28), ded_factor: workbook.cell('AA',28),
                co_ins_factor: workbook.cell('AC',28), premium: workbook.cell('AF',28) },

              other: { valuation: workbook.cell('U',29), limit: workbook.cell('W',29),
                rate: workbook.cell('Y',29), ded_factor: workbook.cell('AA',29),
                co_ins_factor: workbook.cell('AC',29), premium: workbook.cell('AF',29) } },
            location_2_property_premium: workbook.cell('AE',33)
            }
        end

        @policy.crime = { central_burglar_alarm: workbook.cell('F',44),
          exclude_safe: workbook.cell('F',45), deductible: workbook.cell('K',44),
          employee_theft: { limit: workbook.cell('F',47), premium: workbook.cell('K',47) },
          forgery_alteration: { limit: workbook.cell('F',47), premium: workbook.cell('K',47) },
          money_securities: { limit: workbook.cell('F',48), premium: workbook.cell('K',48) },
          safe_burglary: { limit: workbook.cell('F',50), premium: workbook.cell('K',50) },
          premises: { limit: workbook.cell('F',51), premium: workbook.cell('K',51) },
          crime_schedule_rating: workbook.cell('J',57), crime_subtotal: workbook.cell('J',56),
          crime_total_premium: workbook.cell('M',62) }

      @policy.general_liability = {
        limits: { general_aggregate: workbook.cell('F',67),
          products_completed_operations: workbook.cell('F',68),
          personal_advertising_injury: workbook.cell('F',69),
          each_occurence: workbook.cell('F',70), fire_damage: workbook.cell('F',71),
          medical_expense: workbook.cell('F',72) },

        gl_exposures: {
          exposure_1: { loc_number: workbook.cell('A',76), cov: workbook.cell('B',76),
            class_description: workbook.cell('C',76), code: workbook.cell('H',76),
            premium_basis: workbook.cell('I',76), type: workbook.cell('K',76),
            base_rate: workbook.cell('M',76), ilf: workbook.cell('O',76),
            premium: workbook.cell('Q',76) },

          exposure_2: { loc_number: workbook.cell('A',77), cov: workbook.cell('B',77),
            class_description: workbook.cell('C',77), code: workbook.cell('H',77),
            premium_basis: workbook.cell('I',77), type: workbook.cell('K',77),
            base_rate: workbook.cell('M',77), ilf: workbook.cell('O',77),
            premium: workbook.cell('Q',77) },

          exposure_3: { loc_number: workbook.cell('A',78), cov: workbook.cell('B',78),
            class_description: workbook.cell('C',78), code: workbook.cell('H',78),
            premium_basis: workbook.cell('I',78), type: workbook.cell('K',78),
            base_rate: workbook.cell('M',78), ilf: workbook.cell('O',78),
            premium: workbook.cell('Q',78) },

          exposure_4: { loc_number: workbook.cell('A',79), cov: workbook.cell('B',79),
            class_description: workbook.cell('C',79), code: workbook.cell('H',79),
            premium_basis: workbook.cell('I',79), type: workbook.cell('K',79),
            base_rate: workbook.cell('M',79), ilf: workbook.cell('O',79),
            premium: workbook.cell('Q',79) } },

        territory: workbook.cell('B',65), additional_insureds_number: workbook.cell('F',87),
        water_gas_tank: workbook.cell('F',88), rate: workbook.cell('J',88),
        gas_premium: workbook.cell('M',88), gl_subtotal: workbook.cell('Q',89),
        multi_location_factor: workbook.cell('Q',90), total_gl_premium: workbook.cell('N',99),
        total_schedule_rating: workbook.cell('Q',91), gl_comments: workbook.cell('B',99)
      }

      @policy.commercial_auto = {
        facticity: workbook.cell('F',102), locations: workbook.cell('K',102),
        hired_auto: workbook.cell('F',103), hired_auto_premium: workbook.cell('Q',103),
        total_auto_premium: workbook.cell('N',107)
      }

      @policy.total_package_premium = workbook.cell('N',109)
      @policy.effective_date = workbook.cell('F',7)
      @policy.expiration_date = workbook.cell('J',7)
    end
end
