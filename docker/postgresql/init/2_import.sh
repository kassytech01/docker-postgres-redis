cd /docker-entrypoint-initdb.d
echo "import dump_data..."
gzip -dc ./dump.gz | psql -h localhost -U postgres -d postgres
echo "done."
