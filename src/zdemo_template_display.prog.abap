*&---------------------------------------------------------------------*
*& Report ZSTR_REPORT_TEMPLATE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zdemo_template_display.

" Includes de Definición
**********************************************************************
INCLUDE zdemo_template_display_top.
INCLUDE zdemo_template_display_c01.

" Pantalla de selección
**********************************************************************
SELECTION-SCREEN BEGIN OF BLOCK b0 WITH FRAME TITLE TEXT-t00.

SELECT-OPTIONS: s_fldate FOR sflight-fldate MODIF ID c01.

SELECTION-SCREEN END OF BLOCK b0.


" Includes de Ejecución
**********************************************************************
INCLUDE zdemo_template_display_f01.
INCLUDE zdemo_template_display_o01.
INCLUDE zdemo_template_display_i01.


" Inicialización
**********************************************************************
INITIALIZATION.
  PERFORM init.


  " Ayudas y Modificación Pantalla de Selección
**********************************************************************
AT SELECTION-SCREEN OUTPUT.
  PERFORM change_screen.


  " Botones en Pantalla de Selección
**********************************************************************
AT USER-COMMAND.



  " Lógica de Ejecución de Programa
**********************************************************************
START-OF-SELECTION.

  PERFORM validate_screen CHANGING gv_error_selscreen.
  IF gv_error_selscreen IS INITIAL.
    PERFORM select_sflight USING s_fldate[].
  ENDIF.


  " Lógica de Visualización de Resultados
**********************************************************************
END-OF-SELECTION.

  IF gv_error_selscreen IS INITIAL.
    CALL SCREEN 9000.
  ENDIF.
