"! <p class="shorttext synchronized" lang="EN">Simple XML Renderer</p>
"! For tags, converts relative ABAP names into camelCase unless overridden by a specific mapping
class zcl_simple_xml_renderer definition
                              public
                              create public.

  public section.

    interfaces: zif_xml_renderer.

    aliases: process for zif_xml_renderer~invoke.

    "! <p class="shorttext synchronized" lang="EN">Creates a simple renderer</p>
    "!
    "! @parameter i_replacing_tags | <p class="shorttext synchronized" lang="EN">Tag names to override</p>
    methods constructor
              importing
                i_replacing_tags type zif_xml_renderer=>t_tag_mappings optional.

  protected section.

    types: begin of _t_typekind_renderer_entry,
             type_kind type abap_typecategory,
             renderer type ref to zif_xml_renderer,
           end of _t_typekind_renderer_entry,
           _t_typekind_renderers_map type hashed table of _t_typekind_renderer_entry with unique key type_kind.

    data _typekind_renderers type zcl_simple_xml_renderer=>_t_typekind_renderers_map.

    data _replacing_tags type zif_xml_renderer=>t_tag_mappings.

endclass.
class zcl_simple_xml_renderer implementation.

  method constructor.

    _replacing_tags = i_replacing_tags.

    _typekind_renderers = value #( ( type_kind = cl_abap_typedescr=>kind_table
                                     renderer = new table_tag_renderer( me ) )
                                   ( type_kind = cl_abap_typedescr=>kind_struct
                                     renderer = new structure_tag_renderer( me ) )
                                   ( type_kind = cl_abap_typedescr=>kind_elem
                                     renderer = new element_tag_renderer( me ) ) ).

  endmethod.
  method zif_xml_renderer~tag_mappings.

    r_val = _replacing_tags.

  endmethod.
  method zif_xml_renderer~invoke.

    final(type) = cl_abap_typedescr=>describe_by_data( i_data ).

    try.

      _typekind_renderers[ type_kind = type->kind ]-renderer->invoke( i_data = i_data
                                                                      i_writer = i_writer ).

    catch cx_sy_itab_line_not_found.

      raise exception new zcx_xml_renderer( new zcl_text_symbol_message( 'Invalid type'(000) ) ).

    endtry.

  endmethod.

endclass.
