{{- define "supabase.analytics.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.analytics.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Supabase analytics fullname
*/}}
{{- define "supabase.analytics.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "analytics" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Extra configuration ConfigMap name (analytics)
*/}}
{{- define "supabase.analytics.extraConfigmapName" -}}
{{- if .Values.analytics.extraConfigExistingConfigmap -}}
    {{- print .Values.analytics.extraConfigExistingConfigmap -}}
{{- else -}}
    {{- printf "%s-extra" (include "supabase.analytics.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
analytics (logflare) credential secret name.
*/}}
{{- define "supabase.analytics.secretName" -}}
{{- coalesce .Values.analytics.existingSecret "supabase-logflare" -}}
{{- end -}}

{{/*
analytics (logflare) credential api secret key
*/}}
{{- define "supabase.analytics.apiSecretKey" -}}
{{- if and .Values.analytics.existingSecret .Values.analytics.existingSecretApiKey -}}
  {{- print .Values.analytics.existingSecretApiKey -}}
{{- else -}}
  {{- print "api-key" -}}
{{- end -}}
{{- end -}}
