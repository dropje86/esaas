apache2-service:
  service.running:
    - name: apache2
    - enable: True
    - require:
      - pkg: apache2

apache2-reload:
  module.wait:
    - name: service.reload
    - m_name: apache2
    - require:
      - pkg: apache2
