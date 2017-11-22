pkg-docker-ce:
  pkg.installed:
    - pkgs:
      - docker-ce

include:
  - .users
  - .defaults
  - .service
