#!/usr/bin/env bash

# Generate Machine Configs for the Talos Cluster

talosctl gen config talos-cluster https://$CONTROL_PLANE_0:6443 --output-dir _out

talosctl apply-config --insecure --nodes $CONTROL_PLANE_0 --file _out/controlplane.yaml

talosctl bootstrap --nodes ${CONTROL_PLANE_0} --endpoints ${CONTROL_PLANE_0} --talosconfig=_out/talosconfig

