*&---------------------------------------------------------------------*
*&  Include           ZSTR_REPORT_TEMPLATE_I01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  VALIDATE_SCREEN
*&---------------------------------------------------------------------*
FORM validate_screen CHANGING uv_error_selscreen TYPE flag.

  CLEAR: uv_error_selscreen.

  IF s_fldate[] IS INITIAL.
    MESSAGE s398(00) WITH TEXT-l01 TEXT-l02 TEXT-e01.
    uv_error_selscreen = abap_true.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  HANDLE_DOUBLE_CLICK
*&---------------------------------------------------------------------*
FORM handle_double_click  USING us_row_id    TYPE lvc_s_row
                                us_column_id TYPE lvc_s_col
                                us_row_no    TYPE lvc_s_roid.

  DATA: ls_sflight TYPE ty_sflight.

  READ TABLE gt_sflight INTO ls_sflight INDEX us_row_no-row_id.
  IF us_column_id-fieldname EQ 'LOG'.
    PERFORM show_log USING ls_sflight-log.
  ELSE.
    " Navegar a Reservas del Vuelo
    PERFORM nav_to_sbook USING ls_sflight.
  ENDIF.

ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  HANDLE_HOTSPOT_CLICK
*&---------------------------------------------------------------------*
FORM handle_hotspot_click  USING us_row_id    TYPE lvc_s_row
                                 us_column_id TYPE lvc_s_col
                                 us_row_no    TYPE lvc_s_roid.

  DATA: ls_sflight TYPE ty_sflight.

  IF us_column_id-fieldname EQ 'CARRID'.
    " Ver datos de la compañía aerea
    READ TABLE gt_sflight INTO ls_sflight INDEX us_row_no-row_id.
    PERFORM popup_carrid_data USING ls_sflight.

  ELSEIF us_column_id-fieldname EQ ''.

    " <-- insert code -->

  ENDIF.


ENDFORM.


*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9000  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_9000 INPUT.

  CASE sy-ucomm.
    WHEN 'SBOOK'.
      PERFORM fcode_nav_to_sbook.
    WHEN '&F03' OR '&F15'.
      PERFORM clear_screen_9000.
      SET SCREEN 0. LEAVE SCREEN.
    WHEN '&F12'.
      PERFORM clear_screen_9000.
      SET SCREEN 0. LEAVE PROGRAM.
  ENDCASE.

ENDMODULE.


*&---------------------------------------------------------------------*
*&      Form  CLEAR_SCREEN_9000
*&---------------------------------------------------------------------*
FORM clear_screen_9000 .

  IF go_alv_sflight IS NOT INITIAL.
    go_alv_sflight->free( ).
  ENDIF.

  IF go_cont_sflight IS NOT INITIAL.
    go_cont_sflight->free( ).
  ENDIF.

  IF go_split_sflight IS NOT INITIAL.
    go_split_sflight->free( ).
  ENDIF.

  CLEAR: go_alv_sflight,      go_cont_sflight,  go_split_sflight,
         gt_fieldcat_sflight, gt_sort_sflight,  gs_layout_sflight,
         gs_variant_sflight,  go_event_sflight.

  CLEAR: gt_sflight[].

ENDFORM.


*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9100  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_9100 INPUT.

  CASE sy-ucomm.
    WHEN '&F03' OR '&F15'.
      PERFORM clear_screen_9100.
      SET SCREEN 0. LEAVE SCREEN.
    WHEN '&F12'.
      PERFORM clear_screen_9100.
      SET SCREEN 0. LEAVE PROGRAM.
  ENDCASE.

ENDMODULE.


*&---------------------------------------------------------------------*
*&      Form  CLEAR_SCREEN_9100
*&---------------------------------------------------------------------*
FORM clear_screen_9100 .

  IF go_alv_sbook IS NOT INITIAL.
    go_alv_sbook->free( ).
  ENDIF.

  IF go_cont_sbook IS NOT INITIAL.
    go_cont_sbook->free( ).
  ENDIF.

  IF go_split_sbook IS NOT INITIAL.
    go_split_sbook->free( ).
  ENDIF.

  CLEAR: go_alv_sbook,      go_cont_sbook,  go_split_sbook,
         gt_fieldcat_sbook, gt_sort_sbook,  gs_layout_sbook,
         gs_variant_sbook.

  CLEAR: gt_sbook[].

ENDFORM.


*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9010  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_9010 INPUT.
  SET SCREEN 0.
  LEAVE SCREEN.
ENDMODULE.
