class PoliciesController < ApplicationController
  before_action :set_policy, only: [:show, :edit, :update, :destroy, :upload]

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

  def upload
    #@policy = Policy.find(params[:id])
    if (params[:file] != nil)
      readWorkbook()

      respond_to do |format|
        if @policy.save
          format.html { render :show, notice: 'Policy was successfully populated' }
          format.json { render :show, status: :ok, location: @policy }
        else
          format.html { render :edit }
          format.json { render json: @policy.errors, status: :unprocessable_entity }
        end
      end
    else
      render :show, notice: 'No file selected'
    end
  end

  # PATCH/PUT /policies/1
  # PATCH/PUT /policies/1.json
  def update
    respond_to do |format|
      if @policy.update(policy_params)
        format.html { render :show, notice: 'Policy was successfully updated' }
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
      params.require(:policy).permit(:policy_number, :client_code, :effective_date, :expiration_date,
      :status, :package_premium_total, :name, :business_type, :type, :mortgagee, :quoted_by,
      :street, :city, :state, :zip, property_attributes: [:premium_total,
      :schedule_rating_pct, :premium_subtotal] )
    end

    def readWorkbook
      # open the speadsheet
      workbook = Roo::Spreadsheet.open(params[:file], extension: :xlsx)

      workbook.default_sheet = 'Rating'

      @policy.name= workbook.cell('C',3)
      @policy.quoted_by= workbook.cell('B',1)
      #@policy.date= workbook.cell('B',2)
      @policy.effective_date= workbook.cell('F',7)
      @policy.expiration_date= workbook.cell('J',7)

      @policy.package_premium_total= workbook.cell('N',109)

      #dba: workbook.cell('B',4),
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

      @policy.property.locations << Location.create!(
        number: 1, premium: workbook.cell('N',33), co_ins: workbook.cell('L',14),
        co_ins_factor: workbook.cell('L',15), ded: workbook.cell('B',15),
        ded_factor: workbook.cell('G',15),

        street: workbook.cell('C',10), city: workbook.cell('B',11),
        state: workbook.cell('G',11), zip: workbook.cell('K',11).to_i.to_s,

        business_type: workbook.cell('L',10), coverage_type: workbook.cell('D',12),
        protection_class: workbook.cell('L',12), updates: workbook.cell('K',13),
        year_built: workbook.cell('B',13), construction_type: workbook.cell('H',13),
        stories: workbook.cell('E',13).to_i, square_feet: workbook.cell('B',14).to_i,
        parking_lot: workbook.cell('H',14).to_i,

        food_limit: workbook.cell('F',17), food_rate: workbook.cell('H',17),
        food_premium: workbook.cell('J',17),

        theft_limit: workbook.cell('F',18), theft_rate: workbook.cell('H',18),
        theft_premium: workbook.cell('J',18),

        enhc_limit: workbook.cell('F',19), enhc_rate: workbook.cell('H',19),
        enhc_premium: workbook.cell('J',19),

        mech_limit: workbook.cell('F',20), mech_rate: workbook.cell('H',20),
        mech_premium: workbook.cell('J',20)
      )

      for i in 23..29 do
        @policy.property.locations.first.exposures << Exposure.create!(
        name: workbook.cell('A',i), valuation: workbook.cell('D',i),
        limit: workbook.cell('F',i), rate: workbook.cell('H',i),
        ded_factor: workbook.cell('J',i), co_ins_factor: workbook.cell('L',i),
        premium: workbook.cell('O',i)
        )
      end

      if (workbook.cell('T',10) != nil)
        @policy.property.locations << Location.create!(
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

          food_limit: workbook.cell('W',17), food_rate: workbook.cell('Y',17),
          food_premium: workbook.cell('AA',17),

          theft_limit: workbook.cell('W',18), theft_rate: workbook.cell('Y',18),
          theft_premium: workbook.cell('AA',18),

          enhc_limit: workbook.cell('W',19), enhc_rate: workbook.cell('Y',19),
          enhc_premium: workbook.cell('AA',19),

          mech_limit: workbook.cell('W',20), mech_rate: workbook.cell('Y',20),
          mech_premium: workbook.cell('AA',20)
        )

        for i in 23..29 do
          @policy.property.locations.second.exposures << Exposure.create!(
          name: workbook.cell('R',i), valuation: workbook.cell('U',i),
          limit: workbook.cell('W',i), rate: workbook.cell('Y',i),
          ded_factor: workbook.cell('AA',i), co_ins_factor: workbook.cell('AC',i),
          premium: workbook.cell('AF',i)
          )
        end
      end

      # Crime
      @policy.crime.premium_total= workbook.cell('M',62)
      @policy.crime.premium_subtotal= workbook.cell('J',56)
      @policy.crime.schedule_rating= workbook.cell('J',57)
      @policy.crime.burglar_alarm= workbook.cell('F',44)
      @policy.crime.exclude_safe= workbook.cell('F',45)
      @policy.crime.ded= workbook.cell('K',44)

      for i in 47..51 do
        @policy.crime.exposures << Exposure.create!(
        name: workbook.cell('A',i), limit: workbook.cell('F',i),
        premium: workbook.cell('K',i)
        )
      end

      # General Liability
      @policy.gl.premium_total= workbook.cell('N',99)
      @policy.gl.premium_subtotal= workbook.cell('Q',89)
      @policy.gl.schedule_rating= workbook.cell('Q',91)
      @policy.gl.multi_loc_factor= workbook.cell('Q',90)
      @policy.gl.gas_premium= workbook.cell('M',88)
      @policy.gl.rate= workbook.cell('J',88)
      @policy.gl.water_gas_tank= workbook.cell('F',88)
      @policy.gl.add_ins_number= workbook.cell('F',87)
      @policy.gl.territory= workbook.cell('B',65)
      @policy.gl.comments= workbook.cell('B',99)

      @policy.gl.gen_agg= workbook.cell('F',67)
      @policy.gl.products_completed_operations= workbook.cell('F',68)
      @policy.gl.personal_advertising_injury= workbook.cell('F',69)
      @policy.gl.each_occurence= workbook.cell('F',70),
      @policy.gl.fire_damage= workbook.cell('F',71)
      @policy.gl.medical_expense= workbook.cell('F',72)

      for i in 77..79 do
        @policy.gl.exposure_gls << ExposureGl.create!(
        name: "Exposure_#{i-76}",
        loc_number: workbook.cell('A',i),
        description: workbook.cell('B',i),
        cov: workbook.cell('C',i),
        code: workbook.cell('H',i),
        premium_basis: workbook.cell('I',i),
        #sales_type: workbook.cell('K',i),
        base_rate: workbook.cell('M',i),
        ilf: workbook.cell('O',i),
        premium: workbook.cell('Q',i)
        )
      end

      # Commerical Auto
      @policy.auto.premium_total= workbook.cell('N',107)
      @policy.auto.locations= workbook.cell('K',102)
      @policy.auto.hired_auto= workbook.cell('F',103)
      @policy.auto.hired_auto_premium= workbook.cell('Q',103)
    end

end
