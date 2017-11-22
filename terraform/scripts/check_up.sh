#!/usr/bin/env bash

start_time=$START_TIME
echo "backing off for 30 seconds to let instances settle and DNS records propagate"
sleep 30

echo
echo -n "waiting for environment to come up.."
while ! curl -I --connect-timeout 5 -s https://hashi-ui.${TF_VAR_domain} 2>&1 | grep -q 'HTTP/1.1 401'; do
    echo -n "."
    sleep 0.5
done

while ! curl -I --connect-timeout 5 -s "https://kibana.${TF_VAR_domain}/login?next=%2F" 2>&1 | grep -q 'HTTP/1.1 200'; do
    echo -n "."
    sleep 0.5
done

end_time=$(date "+%s")

echo "OK"

echo "Total run time: $((end_time-start_time)) seconds"

if [ -d "/Applications/Google Chrome.app" ]; then
    /usr/bin/open -a "/Applications/Google Chrome.app" https://fabio.${TF_VAR_domain} https://consul.${TF_VAR_domain} https://hashi-ui.${TF_VAR_domain} https://kibana.${TF_VAR_domain}
fi
