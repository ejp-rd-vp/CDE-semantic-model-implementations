require 'yarrrml-template-builder'
require 'ffi'  # ffi-1.14.2
require 'json'

class CDE_Transform
  def transform(datatype_tag)
    csv_filename = "/data/#{datatype_tag}.csv"
    return false unless File.exist?("/config/#{datatype_tag}_yarrrml_template.yaml")

    y = YARRRML_Transform.new(datafile: csv_filename, datatype_tag: datatype_tag, baseURI: ENV['baseURI'])
    y.yarrrml_transform
    y.make_fair_data
  end
end
