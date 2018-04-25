#!/usr/bin/env bash

kube() {
  kubectl apply -f $1
}
create() {
  echo "Creating tick..."
  echo "tick is the full stack of InfluxData products running in production configuration"
  kube $BP/namespace.yaml
  kubectl create configmap --namespace tick telegraf-config --from-file $BP/telegraf/telegraf.conf
  kubectl create configmap --namespace tick influxdb-config --from-file $BP/influxdb/influxdb.conf
  kube $BP/influxdb/deployment.yaml
  kube $BP/influxdb/service.yaml
  kube $BP/kapacitor/deployment.yaml
  kube $BP/kapacitor/service.yaml
  kube $BP/telegraf/daemonset.yaml
  kube $BP/chronograf/deployment.yaml
  kube $BP/chronograf/service.yaml
  echo "Waiting for public IP..."
  kubectl get pods --namespace tick -w
}
