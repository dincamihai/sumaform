{% if grains['database'] == 'postgres' %}

include:
  - suse_manager_server

postgresql_main_configuration:
  file.append:
    - name: /var/lib/pgsql/data/postgresql.conf
    - text:
      {% if grains.get('for_development_only') %}
      - listen_addresses = '*'
      {% endif %}
      {% if grains.get('unsafe_postgres') %}
      - fsync = off
      - full_page_writes = off
      {% endif %}
    - require:
      - sls: suse_manager_server

postgresql_hba_configuration:
  file.append:
    - name: /var/lib/pgsql/data/pg_hba.conf
    - text: host    all     all       0.0.0.0/0      md5
    - require:
      - sls: suse_manager_server

postgresql:
  service.running:
    - watch:
      - file: postgresql_main_configuration
      - file: postgresql_hba_configuration
    - require:
      - file: postgresql_main_configuration
      - file: postgresql_hba_configuration

{% endif %}
