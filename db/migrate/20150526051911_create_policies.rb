class CreatePolicies < ActiveRecord::Migration
  def change
    create_table :policies do |t|

      t.string :policy_number, default: ""
      t.string :status, default: ""
      t.string :client_code, default: ""

      t.date :effective_date, default: '1995-11-08'
      t.date :expiration_date, default: '1995-11-08'

      t.string :forms, default: ""
      t.string :property_forms, default: ""
      t.string :gl_forms, default: ""
      t.string :crime_forms, default: ""
      t.string :auto_forms, default: ""

      t.integer :package_premium_total, default: 0

      t.string, :A, default: ""
      t.date :B, default: '1995-11-08'
      t.date :C, default: '1995-11-08'
      t.string :D, default: ""
      t.string :E, default: ""
      t.string :F, default: ""
      t.string :G, default: ""
      t.string :H, default: ""
      t.string :I, default: ""
      t.string :J, default: ""
      t.decimal :K, default: 0
      t.string :L, default: ""
      t.string :M, default: ""
      t.string :N, default: ""
      t.string :O, default: ""
      t.string :P, default: ""
      t.string :Q, default: ""
      t.string :R, default: ""
      t.decimal :S, default: 0
      t.decimal :T, default: 0
      t.decimal :U, default: 0
      t.string :V, default: ""
      t.string :W, default: ""
      t.decimal :X, default: 0
      t.decimal :Y, default: 0
      t.decimal :Z, default: 0
      t.decimal :AA, default: 0
      t.decimal :AB, default: 0
      t.decimal :AC, default: 0
      t.decimal :AD, default: 0
      t.string :AE, default: ""
      t.string :AF, default: ""
      t.string :AG, default: ""
      t.string :AH, default: ""
      t.string :AI, default: ""
      t.decimal :AJ, default: 0
      t.string :AK, default: ""
      t.string :AL, default: ""
      t.decimal :AM, default: 0
      t.string :AN, default: ""
      t.decimal :AO, default: 0
      t.string :AP, default: ""
      t.decimal :AQ, default: 0
      t.decimal :AR, default: 0
      t.decimal :AS, default: 0
      t.string :AT, default: ""
      t.decimal :AU, default: 0
      t.decimal :AV, default: 0
      t.decimal :AW, default: 0
      t.decimal :AX, default: 0
      t.decimal :AY, default: 0
      t.string :AZ, default: ""
      t.decimal :BA, default: 0
      t.decimal :BB, default: 0
      t.decimal :BC, default: 0
      t.decimal :BD, default: 0
      t.decimal :BE, default: 0
      t.decimal :BF, default: 0
      t.decimal :BG, default: 0
      t.decimal :BH, default: 0
      t.decimal :BI, default: 0
      t.decimal :BJ, default: 0
      t.decimal :BK, default: 0
      t.string :BL, default: ""
      t.string :BM, default: ""
      t.decimal :BN, default: 0
      t.decimal :BO, default: 0
      t.decimal :BP, default: 0
      t.string :BQ, default: ""
      t.decimal :BR, default: 0
      t.string :BS, default: ""
      t.decimal :BT, default: 0
      t.decimal :BU, default: 0
      t.decimal :BV, default: 0
      t.string :BW, default: ""
      t.decimal :BX, default: 0
      t.string :BY, default: ""
      t.decimal :BZ, default: 0
      t.decimal :CA, default: 0
      t.decimal :CB, default: 0
      t.string :CC, default: ""
      t.string :CD, default: ""
      t.decimal :CE, default: 0
      t.decimal :CF, default: 0
      t.decimal :CG, default: 0
      t.decimal :CH, default: 0
      t.decimal :CI, default: 0
      t.decimal :CJ, default: 0
      t.decimal :CK, default: 0
      t.string :CL, default: ""
      t.decimal :CM, default: 0
      t.string :CN, default: ""
      t.decimal :CO, default: 0
      t.string :CP, default: ""
      t.string :CQ, default: ""
      t.decimal :CR, default: 0
      t.decimal :CS, default: 0
      t.string :CT, default: ""
      t.decimal :CU, default: 0
      t.decimal :CV, default: 0
      t.decimal :CW, default: 0
      t.decimal :CX, default: 0
      t.string :CY, default: ""
      t.string :CZ, default: ""
      t.decimal :DA, default: 0
      t.decimal :DB, default: 0
      t.string :DC, default: ""
      t.decimal :DD, default: 0
      t.decimal :DE, default: 0
      t.decimal :DF, default: 0
      t.decimal :DG, default: 0
      t.decimal :DH, default: 0
      t.decimal :DI, default: 0
      t.decimal :DJ, default: 0
      t.decimal :DK, default: 0
      t.decimal :DL, default: 0
      t.decimal :DM, default: 0
      t.decimal :DN, default: 0
      t.string :DO, default: ""
      t.decimal :DP, default: 0
      t.decimal :DQ, default: 0
      t.decimal :DR, default: 0
      t.decimal :DS, default: 0
      t.decimal :DT, default: 0
      t.decimal :DU, default: 0
      t.decimal :DV, default: 0
      t.decimal :DW, default: 0
      t.string :DX, default: ""
      t.decimal :DY, default: 0
      t.decimal :DZ, default: 0
      t.string :EA, default: ""
      t.decimal :EB, default: 0
      t.decimal :EC, default: 0
      t.string :ED, default: ""
      t.decimal :EE, default: 0
      t.decimal :EF, default: 0
      t.decimal :EG, default: 0
      t.decimal :EH, default: 0
      t.decimal :EI, default: 0
      t.string :EJ, default: ""
      t.decimal :EK, default: 0
      t.string :EL, default: ""
      t.string :EM, default: ""
      t.string :EN, default: ""
      t.decimal :EO, default: 0
      t.string :EP, default: ""
      t.string :EQ, default: ""
      t.string :ER, default: ""
      t.string :ES, default: ""
      t.string :ET, default: ""

      t.timestamps null: false
    end

    add_index :policies, :policy_number, unique: true
    add_reference :policies, :broker, index: true, foreign_key: true
  end
end
