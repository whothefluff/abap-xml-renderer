# abap-xml-renderer

ABAP variables to XML format

## Use

- Create an instance of the simple renderer (**optionally** passing static mappings for the names of the tags),
which implements _ZIF_XML_RENDERER_ and handles internal tables, structures, and elemental variables[^1]:
   ```abap
   final(xml_renderer) = new zcl_simple_xml_renderer( ).
   ```
[^1]: You can also implement interface _ZIF_XML_RENDERER_ yourself to create the XML file however you prefer 
- Call the process method with an XML Writer and a variable as arguments:
   ```abap
   final(writer) = cl_sxml_string_writer=>create( ).

   xml_renderer->process( i_writer = cast #( writer )
                          i_data = VAR ).
   ```
- Use the writer as usual:
   ```abap
   final(encoded_xml) = writer->get_output( ).
   ```

### Example

You can run class _ZCL_XML_SIMPLE_RENDERER_EG_APP_ to see how a short XML file can be generated.


# dependencies:
  - https://github.com/whothefluff/abap-exceptions
  - https://github.com/whothefluff/abap-messages
