{{- define "supaplus.analytics.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.analytics.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Supabase analytics fullname
*/}}
{{- define "supaplus.analytics.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "analytics" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Extra configuration ConfigMap name (analytics)
*/}}
{{- define "supaplus.analytics.extraConfigmapName" -}}
{{- if .Values.analytics.extraConfigExistingConfigmap -}}
    {{- print .Values.analytics.extraConfigExistingConfigmap -}}
{{- else -}}
    {{- printf "%s-extra" (include "supaplus.analytics.fullname" .) -}}
{{- end -}}
{{- end -}}
