"! <p class="shorttext synchronized" lang="EN">Runnable example for the simple XML renderer</p>
class zcl_xml_simple_renderer_eg_app definition
                                     public
                                     create public.

  public section.

    interfaces: if_oo_adt_classrun.

  protected section.

endclass.
class zcl_xml_simple_renderer_eg_app implementation.

  method if_oo_adt_classrun~main.

    final(random_dec) = cl_abap_random_decfloat34=>create( conv #( cl_abap_context_info=>get_system_time( ) ) ).

    final(data) = new zcl_xml_simple_renderer_eg_dat( value #( page = value #( header = value #( let today = |{ cl_abap_context_info=>get_system_date( ) date = user }|
                                                                                                     tomorrow = |{ conv d( cl_abap_context_info=>get_system_date( ) + 1 ) date = user }| in
                                                                                                 logo = value #( )
                                                                                                 general_data = `Order details`
                                                                                                 dates = |{ today } - { tomorrow }| )
                                                                               products = value #( table1 = value #( ( code = `101`
                                                                                                                       description = `Smartphone`
                                                                                                                       net = round( val = random_dec->get_next( ) * 1000
                                                                                                                                    dec = 2 ) )
                                                                                                                     ( code = `102`
                                                                                                                       description = `Headphones`
                                                                                                                       net = round( val = random_dec->get_next( ) * 1000
                                                                                                                                    dec = 2 ) )
                                                                                                                     ( code = `103`
                                                                                                                       description = `Laptop`
                                                                                                                       net = round( val = random_dec->get_next( ) * 1000
                                                                                                                                    dec = 2 ) ) ) ) ) ) ) ##NO_TEXT.

    out->write( data->as_xml( ) ).

  endmethod.

endclass.
