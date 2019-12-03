*&---------------------------------------------------------------------*
*&  Include           ZSTR_REPORT_TEMPLATE_O01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  CHANGE_SCREEN
*&---------------------------------------------------------------------*
FORM change_screen .

  LOOP AT SCREEN.
    IF screen-group1 EQ 'C01'.

    ELSEIF screen-group1 EQ 'C02'.

    ENDIF.

  ENDLOOP.

ENDFORM.                    "change_screen


*&---------------------------------------------------------------------*
*&      Form  SHOW_LOG
*&---------------------------------------------------------------------*
FORM show_log USING ut_log TYPE ztt_bal_msg.

  DATA: ls_log   TYPE bal_s_msg,
        lv_zeile TYPE int4.

  IF ut_log[] IS INITIAL.
    MESSAGE s398(00) WITH text-i01.
  ELSE.

    CALL FUNCTION 'MESSAGES_INITIALIZE'.
    LOOP AT ut_log INTO ls_log.

      IF ls_log-msgid EQ 'X' OR
         ls_log-msgid EQ 'A'.
        ls_log-msgid = 'E'.
      ENDIF.

      CALL FUNCTION 'MESSAGE_STORE'
        EXPORTING
          arbgb                  = ls_log-msgid
          msgty                  = ls_log-msgty
          msgv1                  = ls_log-msgv1
          msgv2                  = ls_log-msgv2
          msgv3                  = ls_log-msgv3
          msgv4                  = ls_log-msgv4
          txtnr                  = ls_log-msgno
          zeile                  = lv_zeile
        EXCEPTIONS
          message_type_not_valid = 1
          not_active             = 2
          OTHERS                 = 3.

      lv_zeile = lv_zeile + 1.

    ENDLOOP.

    CALL FUNCTION 'MESSAGES_STOP'
      EXCEPTIONS
        a_message = 1
        e_message = 2
        i_message = 3
        w_message = 4
        OTHERS    = 5.

    CALL FUNCTION 'MESSAGES_SHOW'
      EXPORTING
        i_use_grid         = 'X'
      EXCEPTIONS
        inconsistent_range = 1
        no_messages        = 2
        OTHERS             = 3.

  ENDIF.

ENDFORM.                    "show_log


*&---------------------------------------------------------------------*
*&      Module  STATUS_9000  OUTPUT
*&---------------------------------------------------------------------*
MODULE status_9000 OUTPUT.
  SET PF-STATUS 'LIST_SFLIGHT'.
  SET TITLEBAR 'TIT_SFLIGHT'.
ENDMODULE.                    "status_9000 OUTPUT


*&---------------------------------------------------------------------*
*&      Module  ALV_9000  OUTPUT
*&---------------------------------------------------------------------*
MODULE alv_9000 OUTPUT.
  PERFORM alv_9000.
ENDMODULE.                    "alv_9000 OUTPUT


*&---------------------------------------------------------------------*
*&      Form  ALV_9000
*&---------------------------------------------------------------------*
FORM alv_9000 .

  DATA: ls_stable TYPE lvc_s_stbl.

  IF go_alv_sflight IS INITIAL.
    " Splitter de 1x1 para capturar pantalla completa
    CREATE OBJECT go_split_sflight
      EXPORTING
        metric            = '0001'
        parent            = cl_gui_container=>default_screen
        rows              = 1
        columns           = 1
      EXCEPTIONS
        cntl_error        = 1
        cntl_system_error = 2
        OTHERS            = 3.

    go_cont_sflight = go_split_sflight->get_container( row = 1 column = 1 ).

    CREATE OBJECT go_alv_sflight
      EXPORTING
        i_parent = go_cont_sflight.

    " Asignar Evento Doble Click a implementación local
    CREATE OBJECT go_event_sflight.
    SET HANDLER go_event_sflight->handle_double_click  FOR go_alv_sflight.
    SET HANDLER go_event_sflight->handle_hotspot_click FOR go_alv_sflight.

    PERFORM catalogo_9000.
*    PERFORM sort_9000.

    gs_variant_sflight-report  = sy-repid.
    gs_layout_sflight-sel_mode = 'A'.

    CALL METHOD go_alv_sflight->set_table_for_first_display
      EXPORTING
        is_layout       = gs_layout_sflight
        is_variant      = gs_variant_sflight
        i_save          = 'A'
      CHANGING
        it_outtab       = gt_sflight[]
        it_fieldcatalog = gt_fieldcat_sflight
        it_sort         = gt_sort_sflight.

  ELSE.
    " Refrescar ALV y mantener posición barras desplazamiento
    ls_stable-row = 'X'.
    ls_stable-col = 'X'.

    go_alv_sflight->refresh_table_display(
      EXPORTING
        is_stable      = ls_stable
      EXCEPTIONS
        finished       = 1
        OTHERS         = 2 ).

  ENDIF.

ENDFORM.                                                    "alv_9000


*&---------------------------------------------------------------------*
*&      Form  CATALOGO_9000
*&---------------------------------------------------------------------*
FORM catalogo_9000 .

  DATA: ls_fcat TYPE lvc_s_fcat.
  FIELD-SYMBOLS: <fs_fcat> TYPE lvc_s_fcat.


  CLEAR: gt_fieldcat_sflight[].

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name       = 'SFLIGHT'
    CHANGING
      ct_fieldcat            = gt_fieldcat_sflight
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.

  CLEAR: ls_fcat.
  ls_fcat-fieldname = 'STATUS'.
  ls_fcat-coltext   = text-h01.
  ls_fcat-scrtext_m = text-h01.
  ls_fcat-hotspot   = 'X'.
  ls_fcat-outputlen = 12.
  ls_fcat-no_out    = 'X'.
  APPEND ls_fcat TO gt_fieldcat_sflight.

  " Añadir marca para evento Hotspot
  READ TABLE gt_fieldcat_sflight ASSIGNING <fs_fcat>
    WITH KEY fieldname = 'CARRID'.
  IF sy-subrc EQ 0.
    <fs_fcat>-hotspot = 'X'.
  ENDIF.

ENDFORM.                    "catalogo_9000


*&---------------------------------------------------------------------*
*&      Module  STATUS_9100  OUTPUT
*&---------------------------------------------------------------------*
MODULE status_9100 OUTPUT.
  SET PF-STATUS 'LIST_SBOOK'.
  SET TITLEBAR 'TIT_SBOOK'.
ENDMODULE.                    "status_9100 OUTPUT


*&---------------------------------------------------------------------*
*&      Module  ALV_9100  OUTPUT
*&---------------------------------------------------------------------*
MODULE alv_9100 OUTPUT.
  PERFORM alv_9100.
ENDMODULE.                    "alv_9100 OUTPUT


*&---------------------------------------------------------------------*
*&      Form  ALV_9100
*&---------------------------------------------------------------------*
FORM alv_9100 .

  DATA: ls_stable TYPE lvc_s_stbl.

  IF go_alv_sbook IS INITIAL.
    " Splitter de 1x1 para capturar pantalla completa
    CREATE OBJECT go_split_sbook
      EXPORTING
        metric            = '0001'
        parent            = cl_gui_container=>default_screen
        rows              = 1
        columns           = 1
      EXCEPTIONS
        cntl_error        = 1
        cntl_system_error = 2
        OTHERS            = 3.

    go_cont_sbook = go_split_sbook->get_container( row = 1 column = 1 ).

    CREATE OBJECT go_alv_sbook
      EXPORTING
        i_parent = go_cont_sbook.

    PERFORM catalogo_9100.
*    PERFORM sort_9100.

    gs_variant_sbook-report  = sy-repid.
    gs_layout_sbook-sel_mode = 'A'.

    CALL METHOD go_alv_sbook->set_table_for_first_display
      EXPORTING
        is_layout       = gs_layout_sbook
        is_variant      = gs_variant_sbook
        i_save          = 'A'
      CHANGING
        it_outtab       = gt_sbook[]
        it_fieldcatalog = gt_fieldcat_sbook
        it_sort         = gt_sort_sbook.

  ELSE.
    " Refrescar ALV y mantener posición barras desplazamiento
    ls_stable-row = 'X'.
    ls_stable-col = 'X'.

    go_alv_sbook->refresh_table_display(
      EXPORTING
        is_stable      = ls_stable
      EXCEPTIONS
        finished       = 1
        OTHERS         = 2 ).

  ENDIF.

ENDFORM.                                                    "alv_9100


*&---------------------------------------------------------------------*
*&      Form  CATALOGO_9100
*&---------------------------------------------------------------------*
FORM catalogo_9100 .

  DATA: ls_fcat TYPE lvc_s_fcat.

  CLEAR: gt_fieldcat_sbook[].

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name       = 'SBOOK'
    CHANGING
      ct_fieldcat            = gt_fieldcat_sbook
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.

ENDFORM.                    "catalogo_9100


*&---------------------------------------------------------------------*
*&      Module  STATUS_9010  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_9010 OUTPUT.
  SET PF-STATUS 'POPUP_SCARR'.
  SET TITLEBAR 'TIT_SCARR'.
ENDMODULE.                    "status_9010 OUTPUT
