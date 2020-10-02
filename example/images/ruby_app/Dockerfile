FROM <%= image_url(:app_sources) %> AS app_sources
FROM <%= image_url(:ruby) %>

COPY --from=app_sources /app /app

RUN ruby /app/source.rb

COPY example_file.txt example_file.txt