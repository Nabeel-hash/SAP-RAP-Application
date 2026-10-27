*"* ABAP Unit tests for ZCL_TMD_ADDRESS_GENERATOR
*"* Cover the spec's positive tests 8, 12, 13, 14 and negative tests 5-10.
CLASS ltc_generator DEFINITION FINAL FOR TESTING
  DURATION SHORT RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA cut TYPE REF TO zcl_tmd_address_generator.

    METHODS setup.
    METHODS street_increment_by_2      FOR TESTING RAISING cx_static_check.
    METHODS street_concatenation       FOR TESTING RAISING cx_static_check.
    METHODS apartment_a1_by_number     FOR TESTING RAISING cx_static_check.
    METHODS apartment_1_dash_a_letter  FOR TESTING RAISING cx_static_check.
    METHODS apartment_numeric_101      FOR TESTING RAISING cx_static_check.
    METHODS zero_increment_rejected    FOR TESTING.
    METHODS house_number_zero_rejected FOR TESTING.
    METHODS negative_count_rejected    FOR TESTING.
    METHODS invalid_format_rejected    FOR TESTING.
    METHODS letter_overflow_rejected   FOR TESTING.
    METHODS supplement_too_long        FOR TESTING.

    METHODS street_input
      RETURNING VALUE(rs_input) TYPE zcl_tmd_address_generator=>ty_input.
    METHODS apartment_input
      RETURNING VALUE(rs_input) TYPE zcl_tmd_address_generator=>ty_input.
    METHODS assert_rejected
      IMPORTING is_input TYPE zcl_tmd_address_generator=>ty_input.
ENDCLASS.


CLASS ltc_generator IMPLEMENTATION.

  METHOD setup.
    cut = NEW #( ).
  ENDMETHOD.

  METHOD street_input.
    rs_input = VALUE #( mode              = zcl_tmd_address_generator=>c_mode-street_number
                        number_of_objects = 3
                        house_number      = `100`
                        increment_value   = 2
                        street_direction  = `N`
                        street_name       = `Main`
                        street_suffix     = `ST` ).
  ENDMETHOD.

  METHOD apartment_input.
    rs_input = VALUE #( mode                 = zcl_tmd_address_generator=>c_mode-apartment
                        number_of_objects    = 3
                        house_number         = `250`
                        increment_value      = 1
                        increment_by         = zcl_tmd_address_generator=>c_increment_by-number
                        street_name          = `Oak`
                        street_suffix        = `AVE`
                        unit_type            = `APT`
                        letter_number_format = `A1`
                        start_letter         = `A`
                        start_number         = 1 ).
  ENDMETHOD.

  METHOD street_increment_by_2.
    DATA(lt_target) = cut->generate( street_input( ) ).
    cl_abap_unit_assert=>assert_equals( act = lines( lt_target ) exp = 3 ).
    cl_abap_unit_assert=>assert_equals( act = lt_target[ 1 ]-house_number exp = `100` ).
    cl_abap_unit_assert=>assert_equals( act = lt_target[ 3 ]-house_number exp = `104` ).
    cl_abap_unit_assert=>assert_equals( act = lt_target[ 3 ]-group_no     exp = 3 ).   " 1 CO per row
  ENDMETHOD.

  METHOD street_concatenation.
    DATA(lt_target) = cut->generate( street_input( ) ).
    cl_abap_unit_assert=>assert_equals( act = lt_target[ 1 ]-street exp = `N MAIN ST` ).
  ENDMETHOD.

  METHOD apartment_a1_by_number.
    DATA(lt_target) = cut->generate( apartment_input( ) ).
    cl_abap_unit_assert=>assert_equals( act = lt_target[ 1 ]-supplement exp = `APT A1` ).
    cl_abap_unit_assert=>assert_equals( act = lt_target[ 3 ]-supplement exp = `APT A3` ).
    cl_abap_unit_assert=>assert_equals( act = lt_target[ 3 ]-house_number exp = `250` ). " same CO address
    cl_abap_unit_assert=>assert_equals( act = lt_target[ 3 ]-group_no exp = 1 ).         " 1 CO, n premises
  ENDMETHOD.

  METHOD apartment_1_dash_a_letter.
    DATA(ls_input) = apartment_input( ).
    ls_input-letter_number_format = `1-A`.
    ls_input-increment_by         = zcl_tmd_address_generator=>c_increment_by-letter.
    DATA(lt_target) = cut->generate( ls_input ).
    cl_abap_unit_assert=>assert_equals( act = lt_target[ 1 ]-supplement exp = `APT 1-A` ).
    cl_abap_unit_assert=>assert_equals( act = lt_target[ 3 ]-supplement exp = `APT 1-C` ).
  ENDMETHOD.

  METHOD apartment_numeric_101.
    DATA(ls_input) = apartment_input( ).
    ls_input-letter_number_format = `N`.
    ls_input-start_number         = 101.
    ls_input-unit_type            = `UNIT`.
    DATA(lt_target) = cut->generate( ls_input ).
    cl_abap_unit_assert=>assert_equals( act = lt_target[ 1 ]-supplement exp = `UNIT 101` ).
    cl_abap_unit_assert=>assert_equals( act = lt_target[ 3 ]-supplement exp = `UNIT 103` ).
  ENDMETHOD.

  METHOD zero_increment_rejected.
    DATA(ls_input) = street_input( ).
    ls_input-increment_value = 0.
    assert_rejected( ls_input ).
  ENDMETHOD.

  METHOD house_number_zero_rejected.
    DATA(ls_input) = street_input( ).
    ls_input-house_number = `0`.
    assert_rejected( ls_input ).
  ENDMETHOD.

  METHOD negative_count_rejected.
    DATA(ls_input) = street_input( ).
    ls_input-number_of_objects = -5.
    assert_rejected( ls_input ).
  ENDMETHOD.

  METHOD invalid_format_rejected.
    DATA(ls_input) = apartment_input( ).
    ls_input-letter_number_format = `AA1`.
    assert_rejected( ls_input ).
  ENDMETHOD.

  METHOD letter_overflow_rejected.
    DATA(ls_input) = apartment_input( ).
    ls_input-increment_by      = zcl_tmd_address_generator=>c_increment_by-letter.
    ls_input-start_letter      = `Y`.
    ls_input-number_of_objects = 3.                 " Y, Z, (past Z)
    assert_rejected( ls_input ).
  ENDMETHOD.

  METHOD supplement_too_long.
    DATA(ls_input) = apartment_input( ).
    ls_input-unit_type    = `TRLR`.
    ls_input-start_number = 100000.                 " 'TRLR A100000' = 12 chars > 10
    assert_rejected( ls_input ).
  ENDMETHOD.

  METHOD assert_rejected.
    TRY.
        cut->generate( is_input ).
        cl_abap_unit_assert=>fail( msg = 'Invalid input was accepted' ).
      CATCH zcx_tmd ##NO_HANDLER.
        " expected
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
