# Supaplus

## Introduction

Self-hosting `supabase` is only officially supported using `docker compose` and only supported for deployment on a single node. Running production workloads on `docker compose` is, shall we say, somewhat rock-n-roll... The [community chart](https://github.com/supabase-community/supabase-kubernetes/) is also single-node only (as at April 2024), is really only appropriate as a drop-in replacement for the `docker compose` version, and is both fully unsupported and lacking in almost all of the advantages a kubernetes helm chart should bring.

The `bitnami` `helm` chart is multi-node but is missing many features. Because mirroring the `analytics` part (with [`vector`](https://vector.dev/) and [`logflare`](https://logflare.app/)) would mean a lot of work for `bitnami` and they clearly don't care about their `supabase` chart, it is highly unlikely they will ever include support for these components.

This chart attempts to fill in the gaps - basically to provide the missing modules that are provided in the upstream `compose` but in a manner appropriate for installing on a multi-node kubernetes cluster.

## Dependencies

This chart uses `bitnami` charts as dependencies where possible. The base `bitnami` [`supabase`](https://github.com/bitnami/charts/tree/main/bitnami/supabase) chart is used for the main components. The `bitnami` [`postgresql`](https://github.com/bitnami/charts/tree/main/bitnami/postgresql) chart is used for storing the `analytics`/`logflare` data, rather than use the main `supabase` `postgresql` database (you can also you Google BigQuery). The `bitnami` [`minio`](https://github.com/bitnami/charts/tree/main/bitnami/minio) chart is used for providing `s3`-compatible storage (you can also use `s3`, or any other external `s3`-compatible service, or even just a cluster-local volume).

As `bitnami` don't provide a [`vector`](https://vector.dev/) chart, the upstream [`vector/vector`](https://github.com/vectordotdev/helm-charts/) helm chart is used.

## Local resources

`functions` (via [`edge-runtime`](https://github.com/supabase/edge-runtime)) are not in the upstream `bitnami` chart, so are provided here.

`analytics` (via [`logflare`](https://github.com/Logflare/logflare)) are not in the upstream `bitnami` chart, so are provided here.

[`imgproxy`](https://github.com/imgproxy/imgproxy) is not in the upstream `bitnami` chart, so is provided here.

Some original inspiration for the integration of these components was provided by the [community chart](https://github.com/supabase-community/supabase-kubernetes/) but they have been adapted to try and mirror `bitnami` best practices where possible.