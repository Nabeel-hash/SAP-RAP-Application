"! <p class="shorttext synchronized">TMD Replicator - address and unit generation</p>
"! Pure logic, no database access: fully covered by ABAP Unit (see testclasses).
"! Implements the spec's "Address and Premise Generation Rules":
"!  - Street Number mode: house number = start + i * increment, one CO per row
"!  - Apartment mode   : same house number, unit id per premise in format
"!                       A1 | 1A | A 1 | 1 A | A-1 | 1-A | N (numeric only: 101, 102 ...)
"!                       incremented by Number (A1, A2 ...) or Letter (A1, B1 ...)
"!  - Street = direction + street name + suffix (spec: prefix / suffix concatenation)
CLASS zcl_tmd_address_generator DEFINITION
  PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    CONSTANTS:
      BEGIN OF c_mode,
        street_number TYPE c LENGTH 1 VALUE 'S',
        apartment     TYPE c LENGTH 1 VALUE 'A',
      END OF c_mode,
      BEGIN OF c_increment_by,
        number TYPE c LENGTH 1 VALUE 'N',
        letter TYPE c LENGTH 1 VALUE 'L',
      END OF c_increment_by,
      c_max_objects        TYPE i VALUE 999,
      c_supplement_max_len TYPE i VALUE 10.      " AD_HSNM2 = CHAR 10

    TYPES:
      BEGIN OF ty_input,
        mode                 TYPE c LENGTH 1,
        number_of_objects    TYPE i,
        house_number         TYPE string,
        increment_value      TYPE i,
        increment_by         TYPE c LENGTH 1,
        street_direction     TYPE string,
        street_name          TYPE string,
        street_suffix        TYPE string,
        unit_type            TYPE string,
        letter_number_format TYPE string,
        start_letter         TYPE c LENGTH 1,
        start_number         TYPE i,
      END OF ty_input,
      BEGIN OF ty_target,
        group_no     TYPE i,     " street mode: 1 CO per row; apartment: all rows group 1
        seq_no       TYPE i,
        house_number TYPE string,
        street       TYPE string,
        supplement   TYPE string,
      END OF ty_target,
      tt_target TYPE STANDARD TABLE OF ty_target WITH EMPTY KEY.

    "! Generates the target address list. Raises ZCX_TMD with the first invalid parameter.
    METHODS generate
      IMPORTING is_input         TYPE ty_input
      RETURNING VALUE(rt_target) TYPE tt_target
      RAISING   zcx_tmd.

    "! Street = direction + name + suffix, single-spaced, upper case
    METHODS build_street
      IMPORTING iv_direction     TYPE string
                iv_name          TYPE string
                iv_suffix        TYPE string
      RETURNING VALUE(rv_street) TYPE string.

  PRIVATE SECTION.
    CONSTANTS c_alphabet TYPE string VALUE `ABCDEFGHIJKLMNOPQRSTUVWXYZ`.

    METHODS validate        IMPORTING is_input TYPE ty_input RAISING zcx_tmd.
    METHODS street_rows     IMPORTING is_input TYPE ty_input iv_street TYPE string
                            RETURNING VALUE(rt_target) TYPE tt_target.
    METHODS apartment_rows  IMPORTING is_input TYPE ty_input iv_street TYPE string
                            RETURNING VALUE(rt_target) TYPE tt_target
                            RAISING   zcx_tmd.
    METHODS unit_id         IMPORTING is_input TYPE ty_input iv_index TYPE i
                            RETURNING VALUE(rv_unit) TYPE string
                            RAISING   zcx_tmd.
    METHODS letter_at       IMPORTING iv_start TYPE c iv_offset TYPE i
                            RETURNING VALUE(rv_letter) TYPE string
                            RAISING   zcx_tmd.
ENDCLASS.


CLASS zcl_tmd_address_generator IMPLEMENTATION.

  METHOD generate.
    validate( is_input ).
    DATA(lv_street) = build_street( iv_direction = is_input-street_direction
                                    iv_name      = is_input-street_name
                                    iv_suffix    = is_input-street_suffix ).
    rt_target = SWITCH #( is_input-mode
                  WHEN c_mode-street_number THEN street_rows( is_input = is_input iv_street = lv_street )
                  WHEN c_mode-apartment     THEN apartment_rows( is_input = is_input iv_street = lv_street ) ).
  ENDMETHOD.


  METHOD build_street.
    rv_street = to_upper( condense( |{ iv_direction } { iv_name } { iv_suffix }| ) ).
  ENDMETHOD.


  METHOD validate.
    IF is_input-mode <> c_mode-street_number AND is_input-mode <> c_mode-apartment.
      RAISE EXCEPTION TYPE zcx_tmd MESSAGE e010(ztmd) WITH is_input-mode.          " Unsupported replicate mode &1
    ENDIF.
    IF is_input-number_of_objects <= 0 OR is_input-number_of_objects > c_max_objects.
      RAISE EXCEPTION TYPE zcx_tmd MESSAGE e011(ztmd) WITH c_max_objects.          " Number of objects must be 1..&1 (neg. tests 5, 6)
    ENDIF.
    IF is_input-street_name IS INITIAL.
      RAISE EXCEPTION TYPE zcx_tmd MESSAGE e012(ztmd).                              " Street name is required
    ENDIF.

    CASE is_input-mode.
      WHEN c_mode-street_number.
        " House number must be a positive integer (neg. test 9) and increment > 0 (neg. tests 7, 8)
        IF NOT matches( val = is_input-house_number pcre = `^\d+$` )
           OR CONV i( is_input-house_number ) <= 0.
          RAISE EXCEPTION TYPE zcx_tmd MESSAGE e013(ztmd) WITH is_input-house_number. " Invalid starting house number &1
        ENDIF.
        IF is_input-increment_value <= 0.
          RAISE EXCEPTION TYPE zcx_tmd MESSAGE e014(ztmd).                          " Increment must be greater than zero
        ENDIF.

      WHEN c_mode-apartment.
        IF is_input-house_number IS INITIAL.
          RAISE EXCEPTION TYPE zcx_tmd MESSAGE e013(ztmd) WITH is_input-house_number.
        ENDIF.
        IF is_input-increment_value <= 0.
          RAISE EXCEPTION TYPE zcx_tmd MESSAGE e014(ztmd).
        ENDIF.
        IF NOT matches( val = is_input-letter_number_format pcre = `^(A1|1A|A 1|1 A|A-1|1-A|N)$` ).
          RAISE EXCEPTION TYPE zcx_tmd MESSAGE e015(ztmd) WITH is_input-letter_number_format. " Invalid apartment format &1 (neg. test 10)
        ENDIF.
        IF is_input-letter_number_format <> `N`
           AND ( is_input-start_letter IS INITIAL OR find( val = c_alphabet sub = to_upper( is_input-start_letter ) ) < 0 ).
          RAISE EXCEPTION TYPE zcx_tmd MESSAGE e016(ztmd) WITH is_input-start_letter.         " Start letter must be A-Z
        ENDIF.
        IF is_input-start_number < 0.
          RAISE EXCEPTION TYPE zcx_tmd MESSAGE e017(ztmd).                                    " Start number must not be negative
        ENDIF.
    ENDCASE.
  ENDMETHOD.


  METHOD street_rows.
    DATA(lv_start) = CONV i( is_input-house_number ).
    rt_target = VALUE #( FOR i = 0 UNTIL i >= is_input-number_of_objects
                         ( group_no     = i + 1
                           seq_no       = i + 1
                           house_number = |{ lv_start + i * is_input-increment_value }|
                           street       = iv_street ) ).
  ENDMETHOD.


  METHOD apartment_rows.
    DO is_input-number_of_objects TIMES.
      DATA(lv_index) = sy-index - 1.     " captured once; method calls below do not touch it
      DATA(lv_unit)  = unit_id( is_input = is_input iv_index = lv_index ).
      DATA(lv_suppl) = condense( |{ to_upper( is_input-unit_type ) } { lv_unit }| ).

      IF strlen( lv_suppl ) > c_supplement_max_len.
        RAISE EXCEPTION TYPE zcx_tmd MESSAGE e018(ztmd)
          WITH lv_suppl c_supplement_max_len.                     " Supplement &1 longer than &2 characters
      ENDIF.

      APPEND VALUE #( group_no     = 1
                      seq_no       = lv_index + 1
                      house_number = is_input-house_number
                      street       = iv_street
                      supplement   = lv_suppl ) TO rt_target.
    ENDDO.
  ENDMETHOD.


  METHOD unit_id.
    DATA(lv_step) = iv_index * is_input-increment_value.

    IF is_input-letter_number_format = `N`.                       " 101, 102, 103 (positive test 14)
      rv_unit = |{ is_input-start_number + lv_step }|.
      RETURN.
    ENDIF.

    DATA(lv_by_letter) = xsdbool( is_input-increment_by = c_increment_by-letter ).
    DATA(lv_letter) = letter_at( iv_start  = is_input-start_letter
                                 iv_offset = COND #( WHEN lv_by_letter = abap_true THEN lv_step ELSE 0 ) ).
    DATA(lv_number) = |{ is_input-start_number + COND i( WHEN lv_by_letter = abap_true THEN 0 ELSE lv_step ) }|.

    rv_unit = SWITCH #( is_input-letter_number_format
                WHEN `A1`  THEN |{ lv_letter }{ lv_number }|
                WHEN `1A`  THEN |{ lv_number }{ lv_letter }|
                WHEN `A 1` THEN |{ lv_letter } { lv_number }|
                WHEN `1 A` THEN |{ lv_number } { lv_letter }|
                WHEN `A-1` THEN |{ lv_letter }-{ lv_number }|
                WHEN `1-A` THEN |{ lv_number }-{ lv_letter }| ).
  ENDMETHOD.


  METHOD letter_at.
    DATA(lv_pos) = find( val = c_alphabet sub = to_upper( iv_start ) ) + iv_offset.
    IF lv_pos > strlen( c_alphabet ) - 1.
      RAISE EXCEPTION TYPE zcx_tmd MESSAGE e019(ztmd) WITH iv_start iv_offset. " Letter sequence passes Z
    ENDIF.
    rv_letter = substring( val = c_alphabet off = lv_pos len = 1 ).
  ENDMETHOD.

ENDCLASS.
