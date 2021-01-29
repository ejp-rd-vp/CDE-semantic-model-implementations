require './YARRRML_Transform.rb'


y = YARRRML_Transform.new(
                          datafile: "./data/sampledata.csv",
                          datatype_tag: "height_experimental")
y.yarrrml_transform
y.make_fair_data

