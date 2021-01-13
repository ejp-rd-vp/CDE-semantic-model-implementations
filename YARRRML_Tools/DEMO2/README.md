
- need to have sdmrdfizer running on port 4000 with a filder ./data mounted as /data

run build_xxx_template to build the appropriate templates
run generate csv then run YARRRML_Transform on it

in the ./data folder, create a csv file with the necessary headings for your desired transform.




y = YARRRML_Transform.new(datafile: "./data/height_experimental.csv", datatype: "height_experimental")
y.yarrrml_transform
y.make_fair_data




## Example of creating a template:
<code>
require "./YARRRML_Template_BuilderII.rb"


# "pid,uniqid,qualityURI,qualityLabel,measurementURI,measurementLabel,processURI,processLabel,height,unitURI,unitLabel,date,comments"

b = YARRRML_Template_BuilderII.new({
  baseURI: "http://marks.test/this/",
  source_name: "patient_height"}
  )

b.person_identifier_role_mappings({
                                    personid_column: "pid",
                                    uniqueid_column: "uniqid",
                                    identifier_type: "https://ejp-rd.eu/vocab/identifier",
                                    person_type: "https://ejp-rd.eu/vocab/Person",
                                    person_role: "patientRole",
                                    role_type: 'obo:OBI_0000093',
                                    role_label: "Patient"
                                    })
b.role_in_process({
    process_type_column: "processURI",  
    process_tag:  "some_height_measuring_process",
    process_label_column: "processLabel", 
    process_start_column: "date", 
    process_end_column: nil,
    })

b.person_has_quality({
    quality_type_column: "qualityURI",  
    quality_tag:  "height_quality",
    quality_label_column: "qualityLabel", 
    })

b.process_hasoutput_output({
    output_nature: "quantitative",
    output_type_column: "measurementURI",
    output_type_label_column: "measurementLabel",
    output_value_column: "height",
    output_value_datatype: "xsd:float",
    output_comments_column: "comments",
    })

b.output_has_unit({
    output_unit_column: "unitURI",
    output_unit_label: "unitLabel"  
})

puts b.generate

</code>