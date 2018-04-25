#!/usr/bin/env bash

kube() {
  kubectl apply -f $1
}
create() {
  echo "Creating tick..."
  echo "tick is the full stack of InfluxData products running in production configuration"
  kube $HOME/tick-kube/namespace.yaml # Tạo namespace cho tick
  # Tạo config map đến telegraf.conf và influxdb.conf
  kubectl create configmap --namespace tick telegraf-config --from-file $HOME/tick-kube/telegraf/telegraf.conf 
  kubectl create configmap --namespace tick influxdb-config --from-file $HOME/tick-kube/influxdb/influxdb.conf
  # Chạy influxdb deployment và service
  kube $HOME/tick-kube/influxdb/deployment.yaml
  kube $HOME/tick-kube/influxdb/service.yaml
  # Chạy kapacitor deployment và service
  kube $HOME/tick-kube/kapacitor/deployment.yaml
  kube $HOME/tick-kube/kapacitor/service.yaml
  # Chạy telegraf daemonset
  kube $HOME/tick-kube/telegraf/daemonset.yaml
  # Chạy chornonograf deployment và service
  kube $HOME/tick-kube/chronograf/deployment.yaml
  kube $HOME/tick-kube/chronograf/service.yaml
  echo "Waiting for running pods..."
  kubectl get pods --namespace tick -w
}
