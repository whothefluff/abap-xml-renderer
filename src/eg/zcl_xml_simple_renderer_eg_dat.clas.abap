"! <p class="shorttext synchronized" lang="EN">Example data model for the simple XML renderer</p>
class zcl_xml_simple_renderer_eg_dat definition
                                     public
                                     create public.

  public section.

    types: begin of header,
             logo type string,
             general_data type string,
             dates type string,
           end of header,
           begin of item_aux,
             code type string,
             description type string,
             net type decfloat34,
           end of item_aux,
           item type standard table of zcl_xml_simple_renderer_eg_dat=>item_aux with empty key,
           begin of products,
             table1 type zcl_xml_simple_renderer_eg_dat=>item,
           end of products,
           begin of page,
              header type zcl_xml_simple_renderer_eg_dat=>header,
              products type zcl_xml_simple_renderer_eg_dat=>products,
           end of page,
           begin of topmost_subform,
             page type zcl_xml_simple_renderer_eg_dat=>page,
           end of topmost_subform.

    methods constructor
              importing
                i_data type zcl_xml_simple_renderer_eg_dat=>topmost_subform.

    methods value
              returning
                value(r_val) type zcl_xml_simple_renderer_eg_dat=>topmost_subform.

    methods as_xml
              returning
                value(r_val) type xstring.

  protected section.

    data _tag_mappings type zif_xml_renderer=>t_tag_mappings.

    data _data type zcl_xml_simple_renderer_eg_dat=>topmost_subform.

endclass.
class zcl_xml_simple_renderer_eg_dat implementation.

  method as_xml.

    data(writer) = cast if_sxml_writer( cl_sxml_string_writer=>create( ) ).

    writer->write_node( writer->new_open_element( `topmostSubform` ) ).

    new zcl_simple_xml_renderer( _tag_mappings )->process( i_writer = writer
                                                           i_data = value( ) ).

    writer->write_node( writer->new_close_element( ) ).

    r_val = cast cl_sxml_string_writer( writer )->get_output( ).

  endmethod.
  method constructor.

    _tag_mappings = value #( ( abap_name = 'TABLE1'
                               xml_name = `Table` ) ) ##NO_TEXT.

    _data = i_data.

  endmethod.
  method value.

    r_val = _data.

  endmethod.

endclass.
