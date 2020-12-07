FROM <%= image_url(:app_sources) %> AS app_sources
FROM <%= image_url(:ruby) %>

COPY --from=app_sources /app /app

COPY test.txt test.txt
COPY README.md README.md

RUN ruby /app/source.rb

COPY example_file.txt <%= build_vars.example_file_name %>