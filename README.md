# EJP-RD Common Data Elements Semantic Model implementation 

<hr>

This repository is fed by a variety of implementations based on **Common Data Element Semantic Model** registry [(see Github page).](https://github.com/ejp-rd-vp/CDE-semantic-model)

**RDF transformation**: From EJP-RD, we have developed [CDE-in-a-box](https://github.com/ejp-rd-vp/cde-in-box) toolkit to help users to obtain RDF-based patient record-level data. This implementation requires two basic elements: **YARRRML templates and CSV datatable** We can find all docuementation to obtain this requirements at his repository, [here](/CDE_version_2.0.0/)


## CDE transformation toolkit (CDE-in-a-box)

The transformation tools make use of YARRRML to capture triple transformation rules. Our YARRRML transformation files take `CSV` as input file format with certain headers for each CDE modules. If you would like to know more about the YARRRML and CSV templates, please click [here](YARRRML_Transform_Templates/README.md).


## RDF transformation locally

You can also perform your RDf transformation locally without using CDE--in-a-box toolkit, we have develop Docker compose images to cover this process

**Instructions:**
```bash
bundle install
gem build   
gem install yarrrml_template_builder-{VERSION}.gem
```
VERSION is some version that will appear in the filename of the gem.


0) Default folder structure, relative to where you will run the transformation script:

```bash
.
./data/   (this folder is mounted into sdmrdfizer - see step 1 below)
./data/mydataX.csv  (input csv files)
./data/mydataY.csv...
./data/triples/  (output FAIR data ends up here)
./config/
./config/***_yarrrml_template.yaml (*** is a one-word tag of the "type" of data, e.g. "height")
```

1) Need to have sdmrdfizer and yarrrml-parser services running ./data mounted as /data and ./config as /config. You can use docker-compose to run both services:

```yaml
version: "2.0"
services:


    yarrrml_transform:
        image: markw/yarrrml-parser-ejp:latest
        container_name: yarrrml_transform
        ports:
            - "3000:3000"
        volumes:
            - ./data:/data


    rdfizer:
        image: markw/sdmrdfizer_ejp:0.5.0
        container_name: rdfizer
        ports:
            - "4000:4000"
        volumes:
            - ./data:/data
            - ./config:/config
```

2) Create your template using a [yarrrml template builder](/CDE_version_2.0.0/YARRRML/) or select the appropriate [YARRRML template](/CDE_version_2.0.0/YARRRML/unifiedCDE_yarrrml_template.yaml). Named it as {TAGNAME}_yarrrrml_template.yaml and put it in the ./config folder, e.g. "height_yarrrml_template.yaml").

3) In the ./data folder, create a CSV file with the necessary headings for your desired transform, following this [documentation](/CDE_version_2.0.0/CSV_template_doc/unified_csv_template.md). Named it as {TAGNAME}.csv, e.g. "height.csv".

4) This TAGNAME is used to coordinate between many of the components during the automation steps, so it must match exactly with the "tag" portion of the template name.

5) Execute the transformation: You can use [rdf_transform.rb](/CDE_version_2.0.0/RDF_tranformation/rdf_transform.rb) by changing the tag described as datatype_tag parameter at YARRRML_Transform:

```ruby
#!ruby

require "yarrrml-template-builder"

$stderr.puts "this script will do an rdf transformation of the height.csv file, in the ./data folder using the yarrrml file in the ./config folder"
$stderr.puts "you must already have the docker-compose up before running this script.  If you see failures, that is likely why :-)"
datatype_tag = "height"  # the "tag" of your data
data_path_client = "./data"
data_path_server = "/data"  # assumes you are running my docker image
config_path_client = "./config"
config_path_server = "/config"  # assumes you are running my docker image
rdfizer_base_url = "http://localhost:4000"  # again, my docker
yarrrml_transform_base_url = "http://localhost:3000"  # again, my docker

y = YARRRML_Transform.new(
	datatype_tag: datatype_tag, 
	data_path_client: data_path_client,
	data_path_server: data_path_server,
	config_path_client: config_path_client,
	config_path_server: config_path_server,
	rdfizer_base_url: rdfizer_base_url,
	yarrrml_transform_base_url: yarrrml_transform_base_url,
	)
y.yarrrml_transform
y.make_fair_data
```