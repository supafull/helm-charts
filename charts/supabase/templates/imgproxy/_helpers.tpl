{{- define "supabase.imgproxy.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.imgproxy.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Supabase imgproxy fullname
*/}}
{{- define "supabase.imgproxy.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "imgproxy" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Extra configuration ConfigMap name (imgproxy)
*/}}
{{- define "supabase.imgproxy.extraConfigmapName" -}}
{{- if .Values.imgproxy.extraConfigExistingConfigmap -}}
    {{- print .Values.imgproxy.extraConfigExistingConfigmap -}}
{{- else -}}
    {{- printf "%s-extra" (include "supabase.imgproxy.fullname" .) -}}
{{- end -}}
{{- end -}}
