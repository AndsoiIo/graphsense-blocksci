
# Export of BlockSci data to Apache Cassandra 

## BlockSci Docker container

Build docker image
```
docker build -t blocksci .
```
or `./docker/build.sh`

Start docker container
```
./docker/start.sh CONTAINER_NAME BLOCKCHAIN_DATA_DIR BLOCKCHAIN_DATA_DIR
```

`CONTAINER_NAME` specifies the name of the docker container;
`BLOCKCHAIN_DATA_DIR` and `BLOCKSCI_DATA_DIR` are the locations of the
data directories on the host system. `BLOCKCHAIN_DATA_DIR` is mapped to
`/var/data/block_data`, and `BLOCKSCI_DATA_DIR` corresponds to
`/var/data/blocksci_data` inside the docker container.

Attach docker container
```
docker exec -ti blocksci_btc /bin/bash
```
or `./docker/attach.sh blocksci_btc`

## BlockSci export

Create a BlockSci config file, e.g., for Bitcoin using the disk mode parser
```
blocksci_parser /var/data/blocksci_data/btc.cfg generate-config bitcoin /var/data/blocksci_data --max-block '-6' --disk /var/data/block_data
```

To run the BlockSci parser, use
```
blocksci_parser /var/data/blocksci_data/btc.cfg update
```

To export BlockSci blockchain data to Apache Cassandra, create a keyspace

```
cqlsh $CASSANDRA_HOST -f schema.cql
```

and use the `blocksci_export.py` script:

```
blocksci_export.py -h
usage: blocksci_export.py [-h] -c BLOCKSCI_DATA
                          [-d CASSANDRA_NODE [CASSANDRA_NODE ...]] -k
                          KEYSPACE [-p NUM_PROC] [-s START_INDEX]
                          [-e END_INDEX]

Export dumped BlockSci data to Apache Cassandra

optional arguments:
  -h, --help            show this help message and exit
  -c BLOCKSCI_DATA, --config BLOCKSCI_DATA
                        BlockSci configuration file
  -d DB_NODE [DB_NODE ...], --db_nodes DB_NODE [DB_NODE ...]
                        List of Cassandra nodes; default "localhost")
  -k KEYSPACE, --keyspace KEYSPACE
                        Cassandra keyspace
  -p NUM_PROC, --processes NUM_PROC
                        number of processes (default 1)
  -s START_INDEX, --start_index START_INDEX
                        start index of the blocks to export (default 0)
  -e END_INDEX, --end_index END_INDEX
                        only blocks with height smaller than this value are
                        included; a negative index counts back from the end
                        (default -1)

GraphSense - http://graphsense.info
```
