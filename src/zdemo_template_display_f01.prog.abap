*&---------------------------------------------------------------------*
*&  Include           ZSTR_REPORT_TEMPLATE_F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  INIT
*&---------------------------------------------------------------------*
FORM init .

  " Recuperar sistema lógico
  CALL FUNCTION 'OWN_LOGICAL_SYSTEM_GET'
    IMPORTING
      own_logical_system             = gv_logsys
    EXCEPTIONS
      own_logical_system_not_defined = 1
      OTHERS                         = 2.

  " Inicializar variable en pantalla de selección
  CLEAR: s_fldate[].
  s_fldate-sign   = 'I'.
  s_fldate-option = 'EQ'.
  s_fldate-low    = sy-datum.
  APPEND s_fldate.

ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  SELECT_SFLIGHT
*&---------------------------------------------------------------------*
FORM select_sflight USING ut_fldate TYPE STANDARD TABLE.

  SELECT * FROM sflight
    INTO CORRESPONDING FIELDS OF TABLE gt_sflight
    WHERE fldate IN ut_fldate.

ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  NAV_TO_SBOOK
*&---------------------------------------------------------------------*
FORM nav_to_sbook USING us_sflight TYPE ty_sflight.

  CLEAR: gt_sbook[].

  SELECT * INTO TABLE gt_sbook
    FROM sbook
    WHERE carrid EQ us_sflight-carrid
      AND connid EQ us_sflight-connid
      AND fldate EQ us_sflight-fldate.

  CALL SCREEN 9100.

ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  FCODE_NAV_TO_SBOOK
*&---------------------------------------------------------------------*
FORM fcode_nav_to_sbook .

  DATA: lt_row_no  TYPE lvc_t_roid,
        ls_row_no  TYPE lvc_s_roid,
        ls_sflight TYPE ty_sflight.

  " Recuperar registro ALV seleccionado
  go_alv_sflight->get_selected_rows( IMPORTING et_row_no = lt_row_no ).
  READ TABLE lt_row_no INTO ls_row_no INDEX 1.
  IF ls_row_no IS NOT INITIAL.

    READ TABLE gt_sflight INTO ls_sflight INDEX ls_row_no-row_id.
    " Navegar a Reservas del Vuelo
    PERFORM nav_to_sbook USING ls_sflight.

  ENDIF.

ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  POPUP_CARRID_DATA
*&---------------------------------------------------------------------*
FORM popup_carrid_data USING us_sflight TYPE ty_sflight.

  CLEAR: gs_scarr.

  " Recuperar datos aerolínea
  SELECT SINGLE * INTO gs_scarr FROM scarr
    WHERE carrid EQ us_sflight-carrid.

  " Visualizar popup
  CALL SCREEN 9010 STARTING AT 25 3.

ENDFORM.
