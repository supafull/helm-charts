{{- define "supabase.functions.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.functions.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Supabase functions fullname
*/}}
{{- define "supabase.functions.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "functions" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Extra configuration ConfigMap name (functions)
*/}}
{{- define "supabase.functions.extraConfigmapName" -}}
{{- if .Values.functions.extraConfigExistingConfigmap -}}
    {{- print .Values.functions.extraConfigExistingConfigmap -}}
{{- else -}}
    {{- printf "%s-extra" (include "supabase.functions.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Default configuration ConfigMap name (functions)
*/}}
{{- define "supabase.functions.defaultConfigmapName" -}}
{{- if .Values.functions.existingConfigmap -}}
    {{- print .Values.functions.existingConfigmap -}}
{{- else -}}
    {{- printf "%s-default" (include "supabase.functions.fullname" .) -}}
{{- end -}}
{{- end -}}
