# Monitoring with Grafana, Influxdb, Telegraf, Kapacitor and Cronograf

To install all the tools in the hosts specified in `inventory` run the folowing ansible commands:

`ansible-playbook metrics.yml`

`ansible-playbook tele.yml`

`ansible-playbook webservers.yml`

Kapacitor creates influxdb subscriptions hooking up to the hostname defined in [kapacitor.conf](https://github.com/influxdata/kapacitor/blob/9611bbf38225b2751704af6d2bfc70c193c5ddbb/etc/kapacitor/kapacitor.conf#L129). I recommend to override the name with the host name or IP of the kapacitor host.

To see Influxdb connections run `SHOW SUBSCRIPTIONS` in influxdb REPL.
