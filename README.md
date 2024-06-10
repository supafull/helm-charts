# Helm charts for deploying Supabase

This repo contains charts and a helm repo for deploying Supabase

Add the repo

```bash
helm repo add supaplus https://supafull.github.io/helm-charts
```

Now copy the `values.example.yaml` (and modify if needed) file locally and

```bash
helm upgrade --install --namespace supatest --create-namespace supatest supaplus/supabase -f values.example.yaml
```

Your cluster will need to have an `nginx` ingress controller in order for the `values.example.yaml` to work as-is, though you should be able to replace with another controller and it *should* "Just Work".


# Important notes and caveats

Please note the following restrictions:
- `imgproxy` currently only works with `minio`, so if you want integrated image transforms, you will need to use `minio` for storage.

# Untested features
- Use of Google BigQuery for analytics