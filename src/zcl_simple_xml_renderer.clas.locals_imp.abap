*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

"! <p class="shorttext synchronized" lang="EN">Utilities</p>
class _ definition
        create private
        abstract
        final.

  public section.

    "! <p class="shorttext synchronized" lang="EN">Returns XML name, either in camelCase (default) or explicitly mapped</p>
    "!
    "! @parameter i_from | <p class="shorttext synchronized" lang="EN">Name in ABAP format</p>
    "! @parameter i_replacing | <p class="shorttext synchronized" lang="EN">Explicit assignments</p>
    "! @parameter r_val | <p class="shorttext synchronized" lang="EN">Computed name</p>
    class-methods compute_tag_name
                    importing
                      i_from type abap_compname
                      i_replacing type zif_xml_renderer=>t_tag_mappings optional
                    returning
                      value(r_val) type string.

endclass.

"! <p class="shorttext synchronized" lang="EN">Base renderer</p>
class tag_renderer definition
                   create public
                   abstract.

  public section.

    interfaces: zif_xml_renderer
                  abstract methods invoke
                  final methods tag_mappings.

    methods constructor
              importing
                i_tag_renderer type ref to zif_xml_renderer.

  protected section.

    data _tag_renderer type ref to zif_xml_renderer.

    data _replacing_tags type zif_xml_renderer=>t_tag_mappings.

endclass.

class table_tag_renderer definition ##CLASS_FINAL
                         create public
                         inheriting from tag_renderer.

  public section.

    methods zif_xml_renderer~invoke redefinition.

endclass.

class structure_tag_renderer definition ##CLASS_FINAL
                             create public
                             inheriting from tag_renderer.

  public section.

    methods zif_xml_renderer~invoke redefinition.

endclass.

class element_tag_renderer definition ##CLASS_FINAL
                           create public
                           inheriting from tag_renderer.

  public section.

    methods zif_xml_renderer~invoke redefinition.

endclass.

**********************************************************************

class _ implementation.

  method compute_tag_name.

    r_val = value #( i_replacing[ abap_name = i_from ]-xml_name
                                  default to_mixed( val = i_from
                                                    case = abap_false ) ).

  endmethod.

endclass.
class tag_renderer implementation.

  method constructor.

    _tag_renderer = i_tag_renderer.

    _replacing_tags = i_tag_renderer->tag_mappings( ).

  endmethod.
  method zif_xml_renderer~tag_mappings.

    r_val = _replacing_tags.

  endmethod.

endclass.
class table_tag_renderer implementation.

  method zif_xml_renderer~invoke.

    field-symbols <tab> type any table.

    final(type) = cl_abap_typedescr=>describe_by_data( i_data ).

    assign i_data to <tab>.

    loop at <tab> assigning field-symbol(<entry>).

      i_writer->write_node( i_writer->new_open_element( _=>compute_tag_name( i_from = exact #( type->get_relative_name( ) )
                                                                             i_replacing = _replacing_tags ) ) ).

      _tag_renderer->invoke( i_writer = i_writer
                             i_data = <entry> ).

      i_writer->write_node( i_writer->new_close_element( ) ).

    endloop.

  endmethod.

endclass.
class structure_tag_renderer implementation.

  method zif_xml_renderer~invoke.

    final(type) = cl_abap_typedescr=>describe_by_data( i_data ).

    final(str_type) = cast cl_abap_structdescr( type ).

    loop at str_type->components into final(component).

      i_writer->write_node( i_writer->new_open_element( _=>compute_tag_name( i_from = component-name
                                                                             i_replacing = _replacing_tags ) ) ).

      assign component component-name of structure i_data to field-symbol(<component_value>).

      _tag_renderer->invoke( i_writer = i_writer
                             i_data = <component_value> ).

      i_writer->write_node( i_writer->new_close_element( ) ).

    endloop.

  endmethod.

endclass.
class element_tag_renderer implementation.

  method zif_xml_renderer~invoke.

    final(value) = i_writer->new_value( ).

    value->set_value( exact string( i_data ) ).

    i_writer->write_node( value ).

  endmethod.

endclass.
