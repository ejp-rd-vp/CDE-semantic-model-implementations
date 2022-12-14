#!ruby

require "yarrrml-template-builder"

$stderr.puts "this script will do an rdf transformation of the height.csv file, in the ./data folder using the yarrrml file in the ./config folder"
$stderr.puts "you must already have the docker-compose up before running this script.  If you see failures, that is likely why :-)"
datatype_tag = "CDE"  # the "tag" of your data
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