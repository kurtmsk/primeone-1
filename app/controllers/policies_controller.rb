class PoliciesController < ApplicationController
  before_action :set_policy, only: [:show, :edit, :update, :destroy, :populate, :download, :forms, :remove_form]

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
    @policy.build_property()
    @policy.build_gl()
    @policy.build_crime()
    @policy.build_auto()

    # add all documents
    @policy.docs.create!({
      form_code:"CP0440(6/95)",	file:"CP0440.html",
      description:"SPOILAGE COVERAGE", var_1: @policy.policy_number,
      var_6: nil
    })
    @policy.docs.create!({
      form_code:"CP1218(6/95)",	file:"CP1218.html",
      description:"LOSS PAYABLE PROVISIONS", var_1: @policy.policy_number
    })
    @policy.docs.create!({
      form_code:"IL0415(04/98)",	file:"IL0415.html",
      description:"PROTECTIVE SAFEGUARDS", var_1: @policy.policy_number,
      var_5: nil, var_6: nil
    })
    @policy.docs.create!({
      form_code:"CG2144(7/98)",	file:"CG2144.html",
      description:"LIMITATION OF COVERAGE/DESIGNATED PREMISES", var_1: @policy.policy_number,
      var_4: nil, var_5: nil, var_6: nil
    })
    @policy.docs.create!({
      form_code:"CG2011(1/96)",	file:"CG2011.html",
      description:"ADD'L INSURED MANAGERS/LESSORS", var_1: @policy.policy_number,
      var_5: nil, var_6: nil
    })
    @policy.docs.create!({
      form_code:"CG2018(11/85)",	file:"CG2018.html",
      description:"ADD'L INSURED MORTGAGEE, ETC.", var_1: @policy.policy_number,
      var_4: nil, var_5: nil, var_6: nil
    })
    @policy.docs.create!({
      form_code:"CG2026(7/04)",	file:"CG2026.html",
      description:"ADD'L INSURED DESIGNATED PERSON", var_1: @policy.policy_number,
      var_5: nil, var_6: nil
    })
    @policy.docs.create!({
      form_code:"CG2028(7/04)",	file:"CG2028.html",
      description:"ADD'L INSURED LESSOR OF LEASED EQUIPMENT", var_1: @policy.policy_number,
      var_3: nil, var_4: nil, var_5: nil, var_6: nil
    })


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

  def find
    @policy = Policy.find_by_policy_number(params[:policy_number])
    if @policy != nil
      redirect_to policy_path(@policy)
    else
      redirect_to policies_path
    end
  end

  # Upload / Populate
  def populate
    if (params[:file] != nil)
      readWorkbook()
    end

    findForms()

    respond_to do |format|
      if @policy.save
        format.html { render :show, notice: 'Policy was successfully populated' }
        format.json { render :show, status: :ok, location: @policy }
      else
        format.html { render :edit }
        format.json { render json: @policy.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /policies/1/forms
  def forms
  end

  # determine which forms should be downloaded
  # GET /policies/1/download
  def download
    @pdfForms = CombinePDF.new

    @pdfForms << CombinePDF.load('app/assets/forms/package/all_forms.pdf')

    form_groups = [:property_forms, :gl_forms, :crime_forms, :auto_forms]

    form_groups.each do |fg|
      if !@policy[fg].empty?
        @policy[fg].split(" ").each do |f|
          f = f.gsub("/", "-")
          begin
            @pdfForms << CombinePDF.load("app/assets/forms/#{fg.to_s}/#{f}.pdf")
          rescue
          end
        end
      end
    end

    send_data @pdfForms.to_pdf, filename: "Forms_#{@policy.policy_number}.pdf", format: 'pdf'
  end

  # PATCH/PUT /policies/1
  # PATCH/PUT /policies/1.json
  def update
    respond_to do |format|
      if @policy.update(policy_params)
        findForms()
        if @policy.save
          format.html { render :show, notice: 'Policy was successfully updated' }
          format.json { render :show, status: :ok, location: @policy }
        else
          format.html { render :edit }
          format.json { render json: @policy.errors, status: :unprocessable_entity }
        end
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

  def remove_form
    @policy.docs.find(params[:doc_id]).update(active: false)

    redirect_to forms_policy_path(@policy)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_policy
      @policy = Policy.find(params[:id])
      @broker = @policy.broker
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def policy_params
      params.require(:policy).permit(:policy_number, :client_code, :effective_date, :expiration_date,
      :status, :package_premium_total, :name, :business_type, :type, :mortgagee, :quoted_by,
      :street, :city, :state, :zip, :forms, :property_forms, :gl_forms, :crime_forms,
      :auto_forms, :broker_id, docs_attributes: [:id, :active, :var_1, :var_2, :var_3, :var_4, :var_5, :var_6] )
    end

    # Find the forms necessary for this policy
    def findForms
      # initialize forms for first page (of mandatory forms)
      @policy.forms = "IL0003(9/08) IL0017(11/98) IL0286(9/08) IL0030(1/06) IL0031(1/06)"

      # add relevant commercial property declarations
      if (@policy.property.premium_total != 0)
        # mandatory forms
        @policy.property_forms = "CP0010(6/07) CP0090(7/88) CP0120(1/08) CP0140(7/06) CP1032(8/08) IL0935(7/02) IL0953(1/08) CP1270(9/96) "
        # optional forms
        # BUSINESS INCOME & EXTRA EXPENSE
        if (!@policy.property.locations.first.exposures.third.limit.nil? && !@policy.property.locations.first.exposures.third.limit != 0)
          @policy.property_forms += "CP0030(6/07) "
        end
        # SPOILAGE COVERAGE **
        if (!@policy.property.locations.first.coverage_type == "Special")
          @policy.property_forms += "CP1030(6/07) "
        end
        # SPECIAL FORM - CAUSE OF LOSS
        if (!@policy.property.locations.first.exposures.fifth.limit.nil? && @policy.property.locations.first.exposures.fifth.limit != 0)
          @policy.property_forms += "CP0440(6/95) "
        end
        # OUTDOOR SIGN
        if (!@policy.property.locations.first.exposures.fourth.limit.nil? && !@policy.property.locations.first.exposures.fourth.limit != 0)
          @policy.property_forms += "CP1440(6/07) "
        end
        # ELITE PROPERTY ENHANCEMENT
        if (@policy.property.locations.first.enhc_premium != 0)
          @policy.property_forms += "PO-PRP-3(12/13) "
        end
        # MANDATORY EQUIPMENT BREAKDOWN PROTECTION COVERAGE & MICHIGAN CHANGES
        if (@policy.property.locations.first.mech_premium != 0)
          @policy.property_forms += "EB0020(08/08) EB0108(09/07) "
        end

        # CP1218(6/95)
        if (@policy.docs.where(form_code:"CP1218(6/95)")[0].active == true)
          @policy.property_forms += "CP1218(6/95) "
        end

        # CP0440(6/95)
        if (@policy.docs.where(form_code:"CP0440(6/95)")[0].active == true)
          @policy.property_forms += "CP0440(6/95) "
        end

        # IL0415(04/98)
        if (@policy.docs.where(form_code:"IL0415(04/98)")[0].active == true)
          @policy.property_forms += "IL0415(04/98) "
        end

        # CG2028(7/04)
        if (@policy.docs.where(form_code:"CG2028(7/04)")[0].active == true)
          @policy.property_forms += "CG2028(7/04)"
        end

      end

      # add relevant general liability declarations
      if (@policy.gl.premium_total != 0)
        # mandatory forms
        @policy.gl_forms = "CG0001(12/07) CG0068(5/09) CG0099(11/85) CG0168(12/4) CG2101(11/85) CG2146(7/98) CG2147(12/07) CG2149(9/99) CG2167(12/04) CG2175(6/08) CG2190(1/06) CG2231(7/98) CG2258(11/85) CG2407(1/96) IL0021(9/08) PO-GL-5(5/12) PO-GL-6(5/12) "
        # optional forms
        # EXCLUSION MEDICAL PAYMENTS
        if (!@policy.gl.medical_expense.nil? && @policy.gl.medical_expense != 0)
          @policy.gl_forms += "CG2135(10/01) "
        end
        # EXCLUSION PERSONAL INJURY
        if (!@policy.gl.personal_advertising_injury.nil? && @policy.gl.personal_advertising_injury != 0)
          @policy.gl_forms += "CG2138(11/85) "
        end
        # EXCLUSION DAMAGE TO PREMISES RENTED
        if (!@policy.gl.fire_damage.nil? && @policy.gl.fire_damage != 0)
          @policy.gl_forms += "CG2145(7/98) "
        end
        # WATER IN THE GAS TANK
        if (!@policy.gl.water_gas_tank == "Yes")
          @policy.gl_forms += "PO_GL_WIG(12/13)"
        end

        # CG2026(7/04)
        if (@policy.docs.where(form_code:"CG2026(7/04)")[0].active == true)
          @policy.gl_forms += "CG2026(7/04)"
        end

        # CG2018(11/85)
        if (@policy.docs.where(form_code:"CG2018(11/85)")[0].active == true)
          @policy.gl_forms += "CG2018(11/85)"
        end

        # CG2011(1/96)
        if (@policy.docs.where(form_code:"CG2011(1/96)")[0].active == true)
          @policy.gl_forms += "CG2011(1/96)"
        end

        # CG2144(7/98)
        if (@policy.docs.where(form_code:"CG2144(7/98)")[0].active == true)
          @policy.gl_forms += "CG2144(7/98)"
        end
      end

      # add relevant crime declarations
      if (@policy.crime.premium_total != 0)
        # mandatory forms
        @policy.crime_forms = "CR0021(5/06) CR0110(8/07) CR0246(8/07) CR0730(3/06) CR0731(3/06) IL0935(7/02) IL0953(1/08) "
        # optional forms
        # EMPLOYEE THEFT AND FORGERY POLICY
        if ((!@policy.crime.exposures.first.limit.nil? && @policy.crime.exposures.first.limit != 0) ||
          (!@policy.crime.exposures.second.limit.nil? && @policy.crime.exposures.second.limit != 0))
          @policy.crime_forms += "CR0029(5/06) "
        end
        # INSIDE THE PREMISES-THEFT OF OTHER PROPERTY
        if (!policy.crime.exposures.fifth.limit.nil? && @policy.crime.exposures.fifth.limit != 0)
          @policy.crime_forms += "CR0405(8/07) "
        end
        # INSIDE THE PREMISES – ROBBERY OF A CUSTODIAN OR SAFE BURGLARY OF MONEY & SECURITIES
        if ((!@policy.crime.exposures.third.limit.nil? && @policy.crime.exposures.third.limit != 0) ||
          (!@policy.crime.exposures.fourth.limit.nil? && @policy.crime.exposures.fourth.limit != 0))
          @policy.crime_forms += "CR0405(8/07) "
        end
      end

      # add relevant commerical auto declarations
      if (@policy.auto.premium_total != "0.00")
        # mandatory forms
        @policy.auto_forms = "CA0110(11/06) CA0217(3/94) CA0001(3/06) CA2384(1/06) PO-CA-1(5/12) "
      end
    end

    # Read the workbook to fill out the policy
    def readWorkbook
      # open the speadsheet
      workbook = Roo::Spreadsheet.open(params[:file], extension: :xlsx)

      workbook.default_sheet = 'Rating'

      @policy.name= workbook.cell('C',3)
      @policy.quoted_by= workbook.cell('B',1)
      #@policy.date= workbook.cell('B',2)
      @policy.effective_date= workbook.cell('F',7)
      @policy.expiration_date= workbook.cell('J',7)

      @policy.dba= workbook.cell('B',4),
      @policy.business_type= workbook.cell('L',5)
      @policy.mortgagee= workbook.cell('S',3)

      @policy.street= workbook.cell('C',5)
      @policy.city= workbook.cell('B',6)
      @policy.state= workbook.cell('G',6)
      @policy.zip= workbook.cell('K',6).to_i.to_s

      # Property
      @policy.property.schedule_rating_pct= workbook.cell('J',36)
      @policy.property.premium_subtotal= workbook.cell('J',35)
      @policy.property.premium_total= workbook.cell('M',41)

      @policy.property.locations.destroy_all # no duplicates
      # First location (locations.first)
      #locationFields = {
      @policy.property.locations.create!(
        number: 1, premium: workbook.cell('N',33),
        co_ins: workbook.cell('L',14), co_ins_factor: workbook.cell('L',15),
        ded: workbook.cell('B',15), ded_factor: workbook.cell('G',15),

        street: workbook.cell('C',10), city: workbook.cell('B',11),
        state: workbook.cell('G',11), zip: workbook.cell('K',11).to_i.to_s,

        business_type: workbook.cell('L',10), coverage_type: workbook.cell('D',12),
        protection_class: workbook.cell('L',12), updates: workbook.cell('K',13),
        year_built: workbook.cell('B',13), construction_type: workbook.cell('H',13),
        stories: workbook.cell('E',13).to_i, square_feet: workbook.cell('B',14).to_i,
        parking_lot: workbook.cell('H',14).to_i,

        #food_limit: workbook.cell('F',17),
        food_rate: workbook.cell('H',17),
        food_premium: workbook.cell('J',17),

        theft_limit: workbook.cell('F',18),
        #theft_rate: workbook.cell('H',18),
        theft_premium: workbook.cell('J',18),

        #enhc_limit: workbook.cell('F',19),
        enhc_rate: workbook.cell('H',19),
        enhc_premium: workbook.cell('J',19),

        #mech_limit: workbook.cell('F',20),
        #mech_rate: workbook.cell('H',20),
        mech_premium: workbook.cell('J',20)
      )
      #if (!@policy.property.locations.where(number:1).exists?)
      #@policy.property.locations.create!(locationFields)

      for i in 23..29 do
        @policy.property.locations.first.exposures.create!(
        name: (workbook.cell('A',i) || ""),
        valuation: (workbook.cell('D',i) || ""),
        limit: (workbook.cell('F',i) || 0),
        rate: (workbook.cell('H',i) || 0),
        ded_factor: (workbook.cell('J',i) || 0),
        co_ins_factor: (workbook.cell('L',i) || 0),
        premium: (workbook.cell('O',i) || 0)
        )
      end
      #else
        #@policy.property.locations.first.update(locationFields)
      #end

      # Earnings should have all 0s
      @policy.property.locations.first.exposures.third.update(valuation: 0,
      ded_factor: 0, co_ins_factor: 0 )

      # Second location (locations.second) (optional)
      if (workbook.cell('T',10) != nil)
        @policy.property.locations.create!(
          number: 2, premium: workbook.cell('AE',33), co_ins: workbook.cell('AC',14),
          co_ins_factor: workbook.cell('AC',15), ded: workbook.cell('S',15),
          ded_factor: workbook.cell('X',15),

          street: workbook.cell('T',10), city: workbook.cell('S',11),
          state: workbook.cell('X',11), zip: workbook.cell('AB',11).to_i.to_s,

          business_type: workbook.cell('AC',10), coverage_type: workbook.cell('U',12),
          protection_class: workbook.cell('AC',12), updates: workbook.cell('AB',13),
          year_built: workbook.cell('S',13), construction_type: workbook.cell('Y',13),
          stories: workbook.cell('V',13).to_i, square_feet: workbook.cell('S',14).to_i,
          parking_lot: workbook.cell('Y',14).to_i,

          #food_limit: workbook.cell('W',17),
          food_rate: workbook.cell('Y',17),
          food_premium: workbook.cell('AA',17),

          theft_limit: workbook.cell('W',18),
          #theft_rate: workbook.cell('Y',18),
          theft_premium: workbook.cell('AA',18),

          #enhc_limit: workbook.cell('W',19),
          enhc_rate: workbook.cell('Y',19),
          enhc_premium: workbook.cell('AA',19),

          #mech_limit: workbook.cell('W',20),
          #mech_rate: workbook.cell('Y',20),
          mech_premium: workbook.cell('AA',20)
        )

        for i in 23..29 do
          @policy.property.locations.second.exposures.create!(
          name: (workbook.cell('R',i) || ""),
          valuation: (workbook.cell('U',i) || ""),
          limit: (workbook.cell('W',i) || 0),
          rate: (workbook.cell('Y',i) || 0),
          ded_factor: (workbook.cell('AA',i) || 0),
          co_ins_factor: (workbook.cell('AC',i) || 0),
          premium: (workbook.cell('AF',i) || 0)
          )
        end

        # Earnings should have all 0s
        @policy.property.locations.second.exposures.third.update(valuation: 0,
        ded_factor: 0, co_ins_factor: 0 )
      end

      # Crime
      @policy.crime.premium_total= workbook.cell('M',62)
      @policy.crime.premium_subtotal= workbook.cell('J',56)
      @policy.crime.schedule_rating= workbook.cell('J',57)
      @policy.crime.burglar_alarm= workbook.cell('F',44)
      @policy.crime.exclude_safe= workbook.cell('F',45)
      @policy.crime.ded= workbook.cell('K',44)

      @policy.crime.exposures.destroy_all # no duplications

      for i in 47..51 do
        @policy.crime.exposures.create!(
        name: workbook.cell('A',i), limit: workbook.cell('F',i),
        premium: workbook.cell('K',i)
        )
      end

      @policy.gl.exposure_gls.destroy_all # no duplications

      for i in 76..84 do
        if (workbook.cell('A',i) != nil)
          @policy.gl.exposure_gls.create!(
            name: "exposure_#{i-75}",
            loc_number: workbook.cell('A',i),
            description: workbook.cell('C',i),
            cov: workbook.cell('B',i),
            code: workbook.cell('H',i),
            premium_basis: workbook.cell('I',i),
            sales_type: workbook.cell('K',i),
            base_rate: workbook.cell('M',i),
            ilf: workbook.cell('O',i),
            premium: workbook.cell('Q',i)
          )
        end
      end

      @policy.gl.gas_premium= workbook.cell('M',88)
      @policy.gl.rate= workbook.cell('J',88)
      @policy.gl.water_gas_tank= workbook.cell('F',88)
      @policy.gl.add_ins_number= workbook.cell('F',87)
      @policy.gl.territory= workbook.cell('B',65).to_i
      @policy.gl.comments= (workbook.cell('B',99) || "none")

      @policy.gl.gen_agg= workbook.cell('F',67)
      @policy.gl.products_completed_operations= workbook.cell('F',68)
      @policy.gl.personal_advertising_injury= workbook.cell('F',69)
      @policy.gl.each_occurence= workbook.cell('F',70)
      @policy.gl.fire_damage= workbook.cell('F',71)
      @policy.gl.medical_expense= workbook.cell('F',72)

      if (workbook.cell('A',89) == nil)
        # General Liability
        @policy.gl.premium_total= workbook.cell('N',99)
        @policy.gl.premium_subtotal= workbook.cell('Q',89)
        @policy.gl.schedule_rating= workbook.cell('Q',91)
        @policy.gl.multi_loc_factor= workbook.cell('Q',90)

        # Commerical Auto
        @policy.auto.premium_total= workbook.cell('N',107)
        @policy.auto.locations= workbook.cell('K',102)
        @policy.auto.hired_auto= workbook.cell('F',103)
        @policy.auto.hired_auto_premium= workbook.cell('Q',103)

        @policy.package_premium_total= workbook.cell('N',109)
      else
        # General Liability
        @policy.gl.premium_total= workbook.cell('N',101)
        @policy.gl.premium_subtotal= workbook.cell('Q',91)
        @policy.gl.schedule_rating= workbook.cell('Q',93)
        @policy.gl.multi_loc_factor= workbook.cell('Q',92)

        # Commerical Auto
        @policy.auto.premium_total= workbook.cell('N',109)
        @policy.auto.locations= workbook.cell('K',104)
        @policy.auto.hired_auto= workbook.cell('F',105)
        @policy.auto.hired_auto_premium= workbook.cell('Q',105)

        @policy.package_premium_total= workbook.cell('N',111)
      end
    end
end
