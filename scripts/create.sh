#!/usr/bin/env bash

kube() {
  kubectl apply -f $1
}
create() {
  echo "Creating tick..."
  echo "tick is the full stack of InfluxData products running in production configuration"
  kube $BP/namespace.yaml # Tạo namespace cho tick
  # Tạo config map đến telegraf.conf và influxdb.conf
  kubectl create configmap --namespace tick telegraf-config --from-file $BP/telegraf/telegraf.conf 
  kubectl create configmap --namespace tick influxdb-config --from-file $BP/influxdb/influxdb.conf
  # Chạy influxdb deployment và service
  kube $BP/influxdb/deployment.yaml
  kube $BP/influxdb/service.yaml
  # Chạy kapacitor deployment và service
  kube $BP/kapacitor/deployment.yaml
  kube $BP/kapacitor/service.yaml
  # Chạy telegraf daemonset
  kube $BP/telegraf/daemonset.yaml
  # Chạy chornonograf deployment và service
  kube $BP/chronograf/deployment.yaml
  kube $BP/chronograf/service.yaml
  echo "Waiting for running pods..."
  kubectl get pods --namespace tick -w
}
