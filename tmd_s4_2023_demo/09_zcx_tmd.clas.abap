"! <p class="shorttext synchronized">TMD demo - exception (usable directly as RAP message)</p>
"! Implements IF_ABAP_BEHV_MESSAGE, so it can be passed as %msg in REPORTED.
"! Use: RAISE EXCEPTION TYPE zcx_tmd MESSAGE e013(ztmd) WITH lv_house.
CLASS zcx_tmd DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_abap_behv_message.

    METHODS constructor
      IMPORTING
        textid   LIKE if_t100_message=>t100key OPTIONAL
        previous LIKE previous OPTIONAL
        severity TYPE if_abap_behv_message=>t_severity DEFAULT if_abap_behv_message=>severity-error.
ENDCLASS.


CLASS zcx_tmd IMPLEMENTATION.

  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    super->constructor( previous = previous ).
    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.
    if_abap_behv_message~m_severity = severity.
  ENDMETHOD.

ENDCLASS.
