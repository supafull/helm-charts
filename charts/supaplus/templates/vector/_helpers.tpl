{{/*
Return the proper vector fullname
FIXME: use the same style as the bitnami external - IF POSSIBLE
*/}}
{{- define "supaplus.vector.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "vector" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Extra configuration ConfigMap name (vector)
*/}}
{{- define "supaplus.vector.extraConfigmapName" -}}
{{- if .Values.vector.extraConfigExistingConfigmap -}}
    {{- print .Values.vector.extraConfigExistingConfigmap -}}
{{- else -}}
    {{- printf "%s-extra" (include "supaplus.vector.fullname" .) -}}
{{- end -}}
{{- end -}}
