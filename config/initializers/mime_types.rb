# Be sure to restart your server when you modify this file.

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf

formats = {
  "application/vnd.ms-excel"                                                => :xls,
  "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"       => :xlsx
}.each do |mime_type, format|
  Mime::Type.register mime_type, format
end
