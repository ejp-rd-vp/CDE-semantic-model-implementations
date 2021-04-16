# Dockerized instructions for using templates

Follow steps 1 to 4 on this Git:  https://github.com/ejp-rd-vp/cde-in-box

Execute:

<code>

docker volume create graphdb-data

</code>

Then replace the docker-compose.yml file with the following:

<code>

version: '3'

services:
  #  Graph DB service. BEFORE you start running docker-compose file please make sure that you have downloaded free edition of graphDB zip files	
  graphdb:
    image: graph-db:9.7.0
    build:
      context: ./graph-db
      dockerfile: Dockerfile        
      args:
        version: 9.7.0
        edition: free
    restart: always
    hostname: graphdb
    ports:
      - 7200:7200
    volumes:
      - graphdb-data:/opt/graphdb/home
    
  #  This service create's `cde` and `fdp` repositories in graphdb	
  graph_db_repo_manager:
    build: ./graph-db-repo-manager
    depends_on:
      - graphdb
    environment:
      - "GRAPH_DB_URL=http://graphdb:7200"

volumes:
  graphdb-data:
    external: true

</code>


Then execute a docker-compose up.   Let it go through the initialization process, and then stop everything.

You now have a docker container 'graph-db:9.7.0' that we will call in this docker-compose file:

