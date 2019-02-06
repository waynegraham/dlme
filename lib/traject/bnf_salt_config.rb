# frozen_string_literal: true

require_relative 'xml_reader'
require_relative 'dlme_json_resource_writer'
require_relative 'macros/dlme'
require_relative 'macros/extraction'
require_relative 'macros/xml'

extend Macros::DLME
extend Macros::Xml

settings do
  provide 'writer_class_name', 'DlmeJsonResourceWriter'
  provide 'reader_class_name', 'XmlReader'
end

record = 'srw:record/srw:recordData/oai_dc:dc'

# Cho Required
to_field 'id', extract_xml("#{record}/dc:identifier[1]", NS), strip
to_field 'cho_title', extract_xml("#{record}/dc:title", NS), strip

# Cho Other
to_field 'cho_contributor', extract_xml("#{record}/dc:contributor", NS), strip
to_field 'cho_creator', extract_xml("#{record}/dc:creator", NS), strip
to_field 'cho_date', extract_xml("#{record}/dc:date", NS), strip
to_field 'cho_description', extract_xml("#{record}/dc:description", NS), strip
to_field 'cho_dc_rights', extract_xml("#{record}/dc:rights", NS), strip
to_field 'cho_format', extract_xml("#{record}/dc:format", NS), strip
to_field 'cho_type', extract_xml("#{record}/dc:type", NS), prepend('text |'), split('|'), first_only, strip, default('text')
to_field 'cho_language', extract_xml("#{record}/dc:language", NS), strip, gsub(/Ottoman Turkish/, 'Turkish, Ottoman')
to_field 'cho_publisher', extract_xml("#{record}/dc:publisher", NS), strip
to_field 'cho_relation', extract_xml("#{record}/dc:relation", NS), strip
to_field 'cho_source', extract_xml("#{record}/dc:source", NS), strip
to_field 'cho_subject', extract_xml("#{record}/dc:subject", NS), strip

# Agg
to_field 'agg_provider', provider
to_field 'agg_data_provider', data_provider
to_field 'agg_is_shown_at', extract_xml('srw:record/srw:extraRecordData/link', NS), strip
to_field 'agg_preview', extract_xml('srw:record/srw:extraRecordData/thumbnail', NS), strip

# Not using agg_is_shown_by
