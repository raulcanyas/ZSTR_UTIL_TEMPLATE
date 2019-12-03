*&---------------------------------------------------------------------*
*&  Include           ZSTR_REPORT_TEMPLATE_C01
*&---------------------------------------------------------------------*

CLASS lcl_event DEFINITION .
  PUBLIC SECTION .
    METHODS:
      " Double Click
      handle_double_click FOR EVENT double_click OF cl_gui_alv_grid
        IMPORTING e_row e_column es_row_no,

      " Hotspot Click
      handle_hotspot_click FOR EVENT hotspot_click OF cl_gui_alv_grid
        IMPORTING e_row_id e_column_id es_row_no    .

ENDCLASS.

CLASS lcl_event IMPLEMENTATION .

  " Double Click
  METHOD handle_double_click .
    PERFORM handle_double_click USING e_row e_column es_row_no .
  ENDMETHOD .

  " Hotspot Click
  METHOD handle_hotspot_click .
    PERFORM handle_hotspot_click USING e_row_id e_column_id es_row_no .
  ENDMETHOD .

ENDCLASS.
