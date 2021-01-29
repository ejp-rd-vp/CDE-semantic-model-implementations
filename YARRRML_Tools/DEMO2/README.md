# NOTA BENE:  This is NOT ready for public use... the code and documentation are changing rapidly without any warning
## Please give me a week or so to settle things down before trying it yourself.

## Execute a CDE Transformation from CSV

0) Default folder structure, relative to where you will run the transformation script:

        .
        ./data/   (this folder is mounted into sdmrdfizer - see step 1 below)
        ./data/mydataX.csv  (input csv files)
        ./data/mydataY.csv...
        ./data/triples/  (output FAIR data ends up here)
        ./config/
        ./config/***_yarrrml_template.yaml (*** is a one-word tag of the "type" of data, e.g. "height")

1) Need to have sdmrdfizer running on port 4000 with a folder ./data mounted as /data

     docker run --name rdfizer --rm -d -p 4000:4000 -v $PWD/data:/data   markw/sdmrdfizer_ejp:0.1.0

2a) Run build_xxx_template to build the appropriate templates (see "Example of creating a template", below).  Remember the names of the CSV columns

2b) Generate CSV with headers sufficient to fill the template

3) Run YARRRML_Transform to genereate nTriples


## More specifically

1) in the ./data folder, create a csv file with the necessary headings for your desired transform.

2) create (or select) the appropriate YARRRML template (in the ./config folder, e.g. "height_yarrrml_template.yaml").  See "example of creating a template" below if you need to create one from-scratch.

3) Identify the "tag" of the YARRML template you want to use (e.g. 'height' for "height_yarrrml_template.yaml" ).  This tag is used to coordinate between many of the components during the automation steps, so it must match exactly with the "tag" portion of the template name.

4) execute the transformation:

        y = YARRRML_Transform.new(datafile: "./data/myHeightData.csv", datatype_tag: "height")
        y.yarrrml_transform
        y.make_fair_data   # output goes to ./data/triples




## Example of creating a template:

### General Discussion:  
The objective of the library is to make it easy to generate a template that matches your situation.  There is a fair amount of flexibility in what parameters are used, which are optional, and which have defaults (SIO-compliant)

personid_column and unique_id column are absolutely mandatory, and do not have a default.

There are three ways of representing a data column (or its default, if that column doesn't exist):

  * You can specify the default value (these parameters are designated "xxxx"  for example "process_type".  
  * You can specify the column header.  These parameters are designated "xxxxxx_column" - for example 'process_type_column'. Specifying "process_type_column" will override any value you provided in "process_type"
  * You can specify nothing, in which case the internal defaults will be used (based on the "base" type for that node in SIO.  Some data is allowed to be nil, and those nodes will not be created.
  
Almost all cases will allow any of those three methods (see detailed documentation for more)

"tags" are used for creating human-readable section names in the output YARRRML.  They may not contain spaces or other odd characters... letters and underscores are fine.  This is not currently sanity-checked, so... 

With that said, here's what a template-building script looks like:

    require "./YARRRML_Template_BuilderII.rb"

    # this is the header of the CSV we are going to transform
    # "pid,uniqid,qualityURI,qualityLabel,measurementURI,measurementLabel,processURI,processLabel,height,unitURI,unitLabel,date,comments"

    b = YARRRML_Template_BuilderII.new({
      baseURI: "http://marks.test/this/", # this should resolve to wherever you are going to serve the data from.
                                          # RDF URLs become e.g. http://marks.test/this/individual_X_Y#patientRole
      source_name: "patient_height"}
      )

    b.person_identifier_role_mappings({
                                        personid_column: "pid",
                                        uniqueid_column: "uniqid",
                                        identifier_type: "https://ejp-rd.eu/vocab/identifier",
                                        person_type: "https://ejp-rd.eu/vocab/Person",
                                        person_role_tag: "patientRole",
                                        role_type: 'obo:OBI_0000093'
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


Note that this will output the template to STDOUT, so capture it to a file.  For everything else to work "correctly" that file should be named
XXXXXX_yarrrml_template.yaml, and should live in the ./config folder.   XXXXXX is the 'tag' of the data type (e.g. 'height')


The "transform.rb" script will run as a demo - using the demo height data in the ./data folder, and the template that is created by the code above.  Output will appear in the ./data/triples folder.
