{{- define "supaplus.functions.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.functions.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Supabase functions fullname
*/}}
{{- define "supaplus.functions.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "functions" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Extra configuration ConfigMap name (functions)
*/}}
{{- define "supaplus.functions.extraConfigmapName" -}}
{{- if .Values.functions.extraConfigExistingConfigmap -}}
    {{- print .Values.functions.extraConfigExistingConfigmap -}}
{{- else -}}
    {{- printf "%s-extra" (include "supaplus.functions.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Default configuration ConfigMap name (functions)
*/}}
{{- define "supaplus.functions.defaultConfigmapName" -}}
{{- if .Values.functions.existingConfigmap -}}
    {{- print .Values.functions.existingConfigmap -}}
{{- else -}}
    {{- printf "%s-default" (include "supaplus.functions.fullname" .) -}}
{{- end -}}
{{- end -}}
