FROM default/app_sources AS app_sources
FROM default/ruby

COPY --from=app_sources /app /app

COPY example_file.txt example_file.txt