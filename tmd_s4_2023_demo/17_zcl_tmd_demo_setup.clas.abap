"! <p class="shorttext synchronized">TMD demo - seed configuration and demo data (run with F9)</p>
"! Fills the scenario table (S01-S08 from the spec), the dropdown lists, and one
"! reference Connection Object with two premises so you can try "use a reference".
"! Re-running it resets everything (also deletes earlier demo requests and drafts).
CLASS zcl_tmd_demo_setup DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PRIVATE SECTION.
    TYPES tt_values TYPE STANDARD TABLE OF ztmd_values WITH EMPTY KEY.
    TYPES tt_scen   TYPE STANDARD TABLE OF ztmd_scen   WITH EMPTY KEY.
    TYPES tt_obj    TYPE STANDARD TABLE OF ztmd_obj    WITH EMPTY KEY.
    METHODS add_list
      IMPORTING iv_list   TYPE ztmd_values-list_id
                iv_codes  TYPE string            " space separated codes; text = code
      CHANGING  ct_values TYPE tt_values.
ENDCLASS.


CLASS zcl_tmd_demo_setup IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    " ---- reset -------------------------------------------------------------
    DELETE FROM ztmd_scen.
    DELETE FROM ztmd_values.
    DELETE FROM ztmd_obj.
    DELETE FROM ztmd_tgt.
    DELETE FROM ztmd_req.
    DELETE FROM ztmd_tgt_d.
    DELETE FROM ztmd_req_d.

    " ---- scenario matrix (spec "Scenario Determination for TMD") ------------
    INSERT ztmd_scen FROM TABLE @( VALUE tt_scen(
      ( scenario_id = 'S01' description = 'Electric'                               electric_flag = abap_true                                                max_rows_total = 200 )
      ( scenario_id = 'S02' description = 'Gas'                                    gas_flag = abap_true                                                     max_rows_total = 200 )
      ( scenario_id = 'S03' description = 'Electric / Gas'                         electric_flag = abap_true gas_flag = abap_true                           max_rows_total = 200 )
      ( scenario_id = 'S04' description = 'Electric - Apartment complex'           electric_flag = abap_true                                                max_rows_total = 200 )
      ( scenario_id = 'S05' description = 'Gas - Apartment complex'                gas_flag = abap_true                                                     max_rows_total = 200 )
      ( scenario_id = 'S06' description = 'Electric / Gas - Apartment complex'     electric_flag = abap_true gas_flag = abap_true                           max_rows_total = 200 )
      ( scenario_id = 'S07' description = 'Electric / Gas / Light - Apartment'     electric_flag = abap_true gas_flag = abap_true light_flag = abap_true    max_rows_total = 200 )
      ( scenario_id = 'S08' description = 'Light only premise'                     light_flag = abap_true                                                   max_rows_total = 200 ) ) ).

    " ---- dropdown lists (spec value tables) ---------------------------------
    DATA(lt_values) = VALUE tt_values(
      ( list_id = 'MODE' value_code = 'S'   value_text = 'Street Number'           sort_order = 1 )
      ( list_id = 'MODE' value_code = 'A'   value_text = 'Apartment Number'        sort_order = 2 )
      ( list_id = 'INCR' value_code = 'N'   value_text = 'Number (A1, A2, A3)'     sort_order = 1 )
      ( list_id = 'INCR' value_code = 'L'   value_text = 'Letter (A1, B1, C1)'     sort_order = 2 )
      ( list_id = 'DIR'  value_code = 'E'   value_text = 'East'                    sort_order = 1 )
      ( list_id = 'DIR'  value_code = 'N'   value_text = 'North'                   sort_order = 2 )
      ( list_id = 'DIR'  value_code = 'NE'  value_text = 'Northeast'               sort_order = 3 )
      ( list_id = 'DIR'  value_code = 'NW'  value_text = 'Northwest'               sort_order = 4 )
      ( list_id = 'DIR'  value_code = 'S'   value_text = 'South'                   sort_order = 5 )
      ( list_id = 'DIR'  value_code = 'SE'  value_text = 'Southeast'               sort_order = 6 )
      ( list_id = 'DIR'  value_code = 'SW'  value_text = 'Southwest'               sort_order = 7 )
      ( list_id = 'DIR'  value_code = 'W'   value_text = 'West'                    sort_order = 8 )
      ( list_id = 'FMT'  value_code = 'A1'  value_text = 'A1'                      sort_order = 1 )
      ( list_id = 'FMT'  value_code = '1A'  value_text = '1A'                      sort_order = 2 )
      ( list_id = 'FMT'  value_code = 'A 1' value_text = 'A 1'                     sort_order = 3 )
      ( list_id = 'FMT'  value_code = '1 A' value_text = '1 A'                     sort_order = 4 )
      ( list_id = 'FMT'  value_code = 'A-1' value_text = 'A-1'                     sort_order = 5 )
      ( list_id = 'FMT'  value_code = '1-A' value_text = '1-A'                     sort_order = 6 )
      ( list_id = 'FMT'  value_code = 'N'   value_text = 'Numeric (101, 102, 103)' sort_order = 7 ) ).

    add_list( EXPORTING iv_list  = 'SFX'
                        iv_codes = `ALY AVE BCH BLF BLVD BND BRK BYP CIR COR CRK CRST CT CTR CV CYN DL DR ESTS EXPY EXT ` &&
                                   `FLDS FLTS FRK GDNS GLN GRV HL HOLW HTS HVN HWY ISLE JCT LK LN LNDG LOOP MDW MDWS OPAS ` &&
                                   `PARK PATH PKWY PL PLZ PT RD RDG REST ROW RST RTE RUN SHLS SHR SPGS SPUR SQ ST TER TRCE ` &&
                                   `TRL VIS VLG VLY VW WAY`
              CHANGING  ct_values = lt_values ).
    add_list( EXPORTING iv_list  = 'UNIT'
                        iv_codes = `# APT BLDG BSMT DEPT FL FRNT HNGR LBBY LOT LOWR OFC PH REAR RM SIDE SLIP SPC STOP STE ` &&
                                   `TRLR UNIT UPPR`
              CHANGING  ct_values = lt_values ).
    INSERT ztmd_values FROM TABLE @lt_values.

    " ---- one reference CO with two premises (try: Apartment + reference CO -> A1, A2 flagged duplicate)
    DATA lv_now TYPE abp_creation_tstmpl.
    GET TIME STAMP FIELD lv_now.
    DATA(lv_user) = cl_abap_context_info=>get_user_technical_name( ).

    INSERT ztmd_obj FROM TABLE @( VALUE tt_obj(
      ( object_type = 'CO'   object_id = 'CO00000001' seq = 1 house_number = '250' street = 'N OAK AVE'
        city_name = 'Spokane' postal_code = '99201' region = 'WA' country = 'US'
        created_by = lv_user created_at = lv_now )
      ( object_type = 'PREM' object_id = 'P000000001' seq = 1 parent_co = 'CO00000001' house_number = '250'
        street = 'N OAK AVE' supplement = 'APT A1' city_name = 'Spokane' postal_code = '99201' region = 'WA'
        country = 'US' created_by = lv_user created_at = lv_now )
      ( object_type = 'PREM' object_id = 'P000000002' seq = 2 parent_co = 'CO00000001' house_number = '250'
        street = 'N OAK AVE' supplement = 'APT A2' city_name = 'Spokane' postal_code = '99201' region = 'WA'
        country = 'US' created_by = lv_user created_at = lv_now )
      ( object_type = 'DL'   object_id = 'DL00000001' seq = 1 parent_co = 'CO00000001' parent_premise = 'P000000001'
        division = 'E' description = 'Electric meter location' created_by = lv_user created_at = lv_now )
      ( object_type = 'DL'   object_id = 'DL00000002' seq = 2 parent_co = 'CO00000001' parent_premise = 'P000000002'
        division = 'E' description = 'Electric meter location' created_by = lv_user created_at = lv_now ) ) ).

    out->write( |TMD demo set up: { lines( lt_values ) } dropdown values, 8 scenarios, | &&
                |reference CO CO00000001 with premises P000000001 (APT A1) and P000000002 (APT A2).| ).
  ENDMETHOD.


  METHOD add_list.
    SPLIT iv_codes AT ` ` INTO TABLE DATA(lt_codes).
    LOOP AT lt_codes INTO DATA(lv_code) WHERE table_line IS NOT INITIAL.
      APPEND VALUE #( list_id    = iv_list
                      value_code = lv_code
                      value_text = lv_code
                      sort_order = sy-tabix ) TO ct_values.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
