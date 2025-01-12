"! <p class="shorttext synchronized" lang="EN">XML renderer</p>
interface zif_xml_renderer public.

    types: begin of t_tag_mapping,
             abap_name type abap_compname,
             xml_name type string,
           end of t_tag_mapping,
           t_tag_mappings type hashed table of zif_xml_renderer=>t_tag_mapping with unique key abap_name.

  "! <p class="shorttext synchronized" lang="EN">Puts an ABAP variable into the provided XML Writer</p>
  "!
  "! @parameter i_writer | <p class="shorttext synchronized" lang="EN">An existing instance of {@link if_sxml_writer}</p>
  "! @parameter i_data | <p class="shorttext synchronized" lang="EN">An ABAP variable</p>
  "! @raising zcx_xml_renderer | <p class="shorttext synchronized" lang="EN">Error occurred during rendering</p>
  methods invoke
            importing
              i_writer type ref to if_sxml_writer
              i_data type any
            raising
              zcx_xml_renderer.

  "! <p class="shorttext synchronized" lang="EN">Returns explicit mappings for tag names between ABAP and XML</p>
  "!
  "! @parameter r_val | <p class="shorttext synchronized" lang="EN">A map of ABAP to XML tag names</p>
  methods tag_mappings
            returning
              value(r_val) type zif_xml_renderer=>t_tag_mappings.

endinterface.
