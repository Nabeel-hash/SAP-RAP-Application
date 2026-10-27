"! <p class="shorttext synchronized">TMD demo - simulated creation of CO / Premise / DL</p>
"! DEMO ONLY. Stands in for the real creation layer on a system without IS-U.
"! It does NOT write to the database: it returns the new keys and the object rows;
"! the RAP saver writes them to ZTMD_OBJ in the save phase (RAP-compliant).
"!
"! On S/4HANA 2025 this class is replaced by ZCL_TMD_API_RAP (released Utilities
"! RAP BOs), called from a bgPF operation - see the design doc. The order of
"! creation and the rules (reuse CO, one DL per commodity) are the same.
CLASS zcl_tmd_demo_engine DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    TYPES:
      BEGIN OF ty_request,
        request_uuid      TYPE sysuuid_x16,
        ref_co            TYPE c LENGTH 30,
        reuse_co          TYPE abap_boolean,
        city_name         TYPE c LENGTH 40,
        postal_code       TYPE c LENGTH 10,
        region            TYPE c LENGTH 3,
        country           TYPE c LENGTH 3,
        plant             TYPE c LENGTH 4,
        electric          TYPE abap_boolean,
        gas               TYPE abap_boolean,
        light             TYPE abap_boolean,
      END OF ty_request,
      BEGIN OF ty_row,
        target_uuid       TYPE sysuuid_x16,
        group_no          TYPE i,
        house_number      TYPE c LENGTH 10,
        street            TYPE c LENGTH 60,
        supplement        TYPE c LENGTH 10,
        connection_object TYPE c LENGTH 30,
        premise           TYPE c LENGTH 10,
        devloc_electric   TYPE c LENGTH 30,
        devloc_gas        TYPE c LENGTH 30,
        devloc_light      TYPE c LENGTH 30,
        row_status        TYPE c LENGTH 1,
        row_message       TYPE c LENGTH 220,
        row_criticality   TYPE int1,
      END OF ty_row,
      tt_row    TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY,
      tt_object TYPE STANDARD TABLE OF ztmd_obj WITH EMPTY KEY.

    METHODS constructor.

    "! Creates (simulates) the objects for one request, in dependency order:
    "! Connection Object -> Premise -> Device Location per commodity.
    METHODS create_objects
      IMPORTING is_request TYPE ty_request
      CHANGING  ct_rows    TYPE tt_row
                ct_objects TYPE tt_object.

  PRIVATE SECTION.
    DATA mv_seq_co   TYPE i.
    DATA mv_seq_prem TYPE i.
    DATA mv_seq_dl   TYPE i.
    DATA mv_user     TYPE abp_creation_user.
    DATA mv_now      TYPE abp_creation_tstmpl.

    METHODS new_co
      IMPORTING is_request   TYPE ty_request
                is_row       TYPE ty_row
      CHANGING  ct_objects   TYPE tt_object
      RETURNING VALUE(rv_id) TYPE ty_row-connection_object.

    METHODS new_premise
      IMPORTING is_request   TYPE ty_request
                is_row       TYPE ty_row
                iv_co        TYPE ty_row-connection_object
      CHANGING  ct_objects   TYPE tt_object
      RETURNING VALUE(rv_id) TYPE ty_row-premise.

    METHODS new_devloc
      IMPORTING is_request   TYPE ty_request
                iv_co        TYPE ty_row-connection_object
                iv_premise   TYPE ty_row-premise
                iv_division  TYPE c
      CHANGING  ct_objects   TYPE tt_object
      RETURNING VALUE(rv_id) TYPE ty_row-devloc_electric.
ENDCLASS.


CLASS zcl_tmd_demo_engine IMPLEMENTATION.

  METHOD constructor.
    " Continue the demo number ranges from what is already saved
    SELECT MAX( seq ) FROM ztmd_obj WHERE object_type = 'CO'   INTO @mv_seq_co.
    SELECT MAX( seq ) FROM ztmd_obj WHERE object_type = 'PREM' INTO @mv_seq_prem.
    SELECT MAX( seq ) FROM ztmd_obj WHERE object_type = 'DL'   INTO @mv_seq_dl.
    mv_user = cl_abap_context_info=>get_user_technical_name( ).
    GET TIME STAMP FIELD mv_now.
  ENDMETHOD.


  METHOD create_objects.
    DATA lv_co TYPE ty_row-connection_object.

    LOOP AT ct_rows ASSIGNING FIELD-SYMBOL(<ls_row>) WHERE row_status <> 'C'.

      " 1 - Connection Object: reuse (apartment complex) or one new CO per group
      IF is_request-reuse_co = abap_true AND is_request-ref_co IS NOT INITIAL.
        lv_co = is_request-ref_co.
      ELSE.
        " rows of the same group share the CO created for the first row of that group
        lv_co = VALUE #( ct_rows[ group_no = <ls_row>-group_no ]-connection_object OPTIONAL ).
        IF lv_co IS INITIAL.
          lv_co = new_co( EXPORTING is_request = is_request is_row = <ls_row>
                          CHANGING  ct_objects = ct_objects ).
        ENDIF.
      ENDIF.
      <ls_row>-connection_object = lv_co.

      " 2 - Premise under the CO, with the generated supplement (APT A1 ...)
      <ls_row>-premise = new_premise( EXPORTING is_request = is_request is_row = <ls_row> iv_co = lv_co
                                      CHANGING  ct_objects = ct_objects ).

      " 3 - One Device Location per commodity of the scenario (DLs = premises x divisions)
      IF is_request-electric = abap_true.
        <ls_row>-devloc_electric = new_devloc( EXPORTING is_request = is_request iv_co = lv_co
                                                         iv_premise = <ls_row>-premise iv_division = 'E'
                                               CHANGING  ct_objects = ct_objects ).
      ENDIF.
      IF is_request-gas = abap_true.
        <ls_row>-devloc_gas = new_devloc( EXPORTING is_request = is_request iv_co = lv_co
                                                    iv_premise = <ls_row>-premise iv_division = 'G'
                                          CHANGING  ct_objects = ct_objects ).
      ENDIF.
      IF is_request-light = abap_true.
        <ls_row>-devloc_light = new_devloc( EXPORTING is_request = is_request iv_co = lv_co
                                                      iv_premise = <ls_row>-premise iv_division = 'L'
                                            CHANGING  ct_objects = ct_objects ).
      ENDIF.

      <ls_row>-row_status      = 'C'.
      <ls_row>-row_criticality = 3.
      <ls_row>-row_message     = |Created CO { lv_co }, premise { <ls_row>-premise } (demo)|.
    ENDLOOP.
  ENDMETHOD.


  METHOD new_co.
    mv_seq_co += 1.
    rv_id = |CO{ mv_seq_co WIDTH = 8 ALIGN = RIGHT PAD = '0' }|.
    APPEND VALUE #( object_type  = 'CO'
                    object_id    = rv_id
                    seq          = mv_seq_co
                    house_number = is_row-house_number
                    street       = is_row-street
                    city_name    = is_request-city_name
                    postal_code  = is_request-postal_code
                    region       = is_request-region
                    country      = is_request-country
                    " spec: maintenance plant stays blank on the Connection Object
                    request_uuid = is_request-request_uuid
                    created_by   = mv_user
                    created_at   = mv_now ) TO ct_objects.
  ENDMETHOD.


  METHOD new_premise.
    mv_seq_prem += 1.
    rv_id = |P{ mv_seq_prem WIDTH = 9 ALIGN = RIGHT PAD = '0' }|.
    APPEND VALUE #( object_type  = 'PREM'
                    object_id    = rv_id
                    seq          = mv_seq_prem
                    parent_co    = iv_co
                    house_number = is_row-house_number
                    street       = is_row-street
                    supplement   = is_row-supplement
                    city_name    = is_request-city_name
                    postal_code  = is_request-postal_code
                    region       = is_request-region
                    country      = is_request-country
                    request_uuid = is_request-request_uuid
                    created_by   = mv_user
                    created_at   = mv_now ) TO ct_objects.
  ENDMETHOD.


  METHOD new_devloc.
    mv_seq_dl += 1.
    rv_id = |DL{ mv_seq_dl WIDTH = 8 ALIGN = RIGHT PAD = '0' }|.
    APPEND VALUE #( object_type    = 'DL'
                    object_id      = rv_id
                    seq            = mv_seq_dl
                    parent_co      = iv_co
                    parent_premise = iv_premise
                    plant          = is_request-plant
                    division       = iv_division
                    description    = SWITCH #( iv_division WHEN 'E' THEN 'Electric meter location'
                                                           WHEN 'G' THEN 'Gas meter location'
                                                           WHEN 'L' THEN 'Street light location' )
                    request_uuid   = is_request-request_uuid
                    created_by     = mv_user
                    created_at     = mv_now ) TO ct_objects.
  ENDMETHOD.

ENDCLASS.
