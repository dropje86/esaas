{% from "nomad/settings.sls" import nomad with context %}

/etc/nomad/jobs:
  file.directory:
    - require:
      - pkg: nomad

{% for (service, job) in nomad.get('jobs', {}).items() %}
/etc/nomad/jobs/{{ service }}.hcl:
  file.managed:
    - user: root
    - group: root
    - mode: '0644'
    - contents: |
       {{ job.contents|indent(7) }}
    - require:
      - file: /etc/nomad/jobs
    - watch_in:
      - cmd: reload-job-{{ service }}
  cmd.run:
    - unless: 'nomad status {{ service }} 2>&1 | egrep -q "Status\s+=\s+running"'
    - name: 'nomad run /etc/nomad/jobs/{{ service }}.hcl'
    - require:
      - file: /etc/nomad/jobs/{{ service }}.hcl

reload-job-{{ service }}:
  cmd.wait:
    - name: 'nomad run /etc/nomad/jobs/{{ service }}.hcl'
{% endfor %}
