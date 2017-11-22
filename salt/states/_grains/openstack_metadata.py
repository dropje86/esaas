#!/usr/bin/env python
import requests
import json
import collections

OS_METADATA_URL = 'http://169.254.169.254/openstack/latest/meta_data.json'
FALLBACK_CACHE_FILE = '/var/cache/salt/metadata.json'


def _get_os_metadata():
    try:
        result = requests.get(OS_METADATA_URL, timeout=3)
    except Exception:
        result = collections.namedtuple('Result', ['ok'])(False)

    try:
        if result.ok:
            data = result.json()

            with open(FALLBACK_CACHE_FILE, 'w') as f:
                json.dump(data, f)
        else:
            with open(FALLBACK_CACHE_FILE, 'r') as f:
                data = json.load(f)
    except Exception:
        data = {}

    return data


def main():
    # initialize a grains dictionary
    grains = _get_os_metadata()

    # set shorthands from metadata
    for (key, value) in grains.get('meta', {}).items():
        grains[key] = value

    return grains

if __name__ == '__main__':
    print(json.dumps(main(), indent=2))
