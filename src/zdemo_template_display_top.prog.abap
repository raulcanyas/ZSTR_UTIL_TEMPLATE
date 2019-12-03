*&---------------------------------------------------------------------*
*&  Include           ZSTR_REPORT_TEMPLATE_TOP
*&---------------------------------------------------------------------*

" Tablas DB
**********************************************************************
TABLES: sflight, scarr.


" Tipos Locales
**********************************************************************
TYPES: BEGIN OF ty_sflight.
        INCLUDE STRUCTURE sflight.
TYPES: status TYPE icon_d,
       log    TYPE ztt_bal_msg,
       END OF ty_sflight.

TYPES: tty_sflight TYPE TABLE OF ty_sflight.


" Tablas internas
**********************************************************************
DATA: gt_sflight TYPE tty_sflight,
      gt_sbook   TYPE TABLE OF sbook.

" Estructuras
**********************************************************************
DATA: gs_scarr TYPE scarr.

" Variables
**********************************************************************
DATA: gv_error_selscreen TYPE flag,
      gv_logsys          TYPE logsys.

" Objetos
**********************************************************************
CLASS: lcl_event DEFINITION DEFERRED.

DATA: go_split_sflight    TYPE REF TO cl_gui_splitter_container,
      go_cont_sflight     TYPE REF TO cl_gui_container,
      go_alv_sflight      TYPE REF TO cl_gui_alv_grid,
      go_event_sflight    TYPE REF TO lcl_event,
      gt_fieldcat_sflight TYPE lvc_t_fcat,
      gt_sort_sflight     TYPE lvc_t_sort,
      gs_layout_sflight   TYPE lvc_s_layo,
      gs_variant_sflight  TYPE disvariant.

DATA: go_split_sbook    TYPE REF TO cl_gui_splitter_container,
      go_cont_sbook     TYPE REF TO cl_gui_container,
      go_alv_sbook      TYPE REF TO cl_gui_alv_grid,
      gt_fieldcat_sbook TYPE lvc_t_fcat,
      gt_sort_sbook     TYPE lvc_t_sort,
      gs_layout_sbook   TYPE lvc_s_layo,
      gs_variant_sbook  TYPE disvariant.


" Constantes
**********************************************************************
" -> Iconos
CONSTANTS: cv_verde        TYPE icon_d VALUE '@5B@',
           cv_rojo         TYPE icon_d VALUE '@5C@',
           cv_complete     TYPE icon_d VALUE '@DF@',
           cv_stop         TYPE icon_d VALUE '@3U@',
           cv_file_error   TYPE icon_d VALUE '@OJ@',
           cv_import       TYPE icon_d VALUE '@KB@',
           cv_green_light  TYPE icon_d VALUE '@08@',
           cv_yellow_light TYPE icon_d VALUE '@09@',
           cv_red_light    TYPE icon_d VALUE '@0A@',
           cv_info         TYPE icon_d VALUE '@19@'.
