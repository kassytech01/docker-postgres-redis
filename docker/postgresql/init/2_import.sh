# cd /docker-entrypoint-initdb.d
echo "import dump_data..."
gzip -dc /docker-entrypoint-initdb.d/dump.gz | psql -h localhost -U postgres -d postgres
echo "done."
