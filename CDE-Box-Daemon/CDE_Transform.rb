require 'yarrrml-template-builder'
require 'ffi'  #ffi-1.14.2
require 'json'

class CDE_Transform  

  def transform(datatype_tag)
    csv_filename = "/data/#{datatype_tag}.csv"
    y = YARRRML_Transform.new(datafile: csv_filename, datatype_tag: datatype_tag)
    y.yarrrml_transform
    y.make_fair_data
  end
end