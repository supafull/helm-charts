{{/* vim: set filetype=mustache: */}}

{{/*
reusable supaplus db env vars
*/}}
{{- define "supaplus.database.envvars" }}
- name: DB_USER
  value: {{ include "supabase.database.user" .Subcharts.supabase | quote }}
- name: DB_HOST
  value: {{ include "supabase.database.host" .Subcharts.supabase | quote }}
- name: DB_PORT
  value: {{ include "supabase.database.port" .Subcharts.supabase | quote }}
- name: DB_NAME
  value: {{ include "supabase.database.name" .Subcharts.supabase | quote }}
- name: DB_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "supabase.database.secretName" .Subcharts.supabase }}
      key: {{ include "supabase.database.passwordKey" .Subcharts.supabase | quote }}
{{- end -}}

{{/*
reusable supabase env vars
*/}}
{{- define "supaplus.database.pgenvvars" }}
- name: PGDATABASE
  value: {{ include "supabase.database.name" .Subcharts.supabase | quote }}
- name: PGUSER
  value: {{ include "supabase.database.user" .Subcharts.supabase | quote }}
- name: PGPASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "supabase.database.secretName" .Subcharts.supabase }}
      key: {{ include "supabase.database.passwordKey" .Subcharts.supabase | quote }}
- name: PGHOST
  value: {{ include "supabase.database.host" .Subcharts.supabase | quote }}
- name: PGPORT
  value: {{ include "supabase.database.port" .Subcharts.supabase | quote }}
{{- end -}}

{{/*
reusable db check-db-ready
*/}}
{{- define "supaplus.database.checkdbready" }}
- name: check-supaplus-db-ready
  image: postgres:16
  command: ['sh', '-c',
    'until psql -c "select 1;";
    do echo waiting for database; sleep 2; done;']
  env:
    {{ include "supaplus.database.pgenvvars" . | indent 4 }}
{{- end -}}

{{/*
Return postgresql Analyticsdb fullname
*/}}
{{- define "supaplus.analyticsdb.database.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "analyticsdb" "chartValues" .Values.analyticsdb "context" $) -}}
{{- end -}}

{{/*
Return the PostgreSQL Analyticsdb Hostname
*/}}
{{- define "supaplus.analyticsdb.database.host" -}}
{{- if .Values.analyticsdb.enabled -}}
    {{- if eq .Values.analyticsdb.architecture "replication" -}}
        {{- printf "%s-%s" (include "supaplus.analyticsdb.database.fullname" .) "primary" | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
        {{- print (include "supaplus.analyticsdb.database.fullname" .) -}}
    {{- end -}}
{{- else -}}
    {{- print .Values.externalDatabaseAnalyticsdb.host -}}
{{- end -}}
{{- end -}}

{{/*
Return postgresql Analyticsdb port
*/}}
{{- define "supaplus.analyticsdb.database.port" -}}
{{- if .Values.analyticsdb.enabled -}}
    {{- print .Values.analyticsdb.service.ports.postgresql -}}
{{- else -}}
    {{- print .Values.externalDatabaseAnalyticsdb.port  -}}
{{- end -}}
{{- end -}}

{{/*
Return the PostgreSQL Analyticsdb Secret Name
*/}}
{{- define "supaplus.analyticsdb.database.secretName" -}}
{{- if .Values.analyticsdb.enabled -}}
    {{- if .Values.analyticsdb.auth.existingSecret -}}
    {{- print .Values.analyticsdb.auth.existingSecret -}}
    {{- else -}}
    {{- print (include "supaplus.analyticsdb.database.fullname" .) -}}
    {{- end -}}
{{- else if .Values.externalDatabaseAnalyticsdb.existingSecret -}}
    {{- print .Values.externalDatabaseAnalyticsdb.existingSecret -}}
{{- else -}}
    {{- printf "%s-%s" (include "common.names.fullname" .) "externaldb-analyticsdb" -}}
{{- end -}}
{{- end -}}

{{/*
Return the PostgreSQL Analyticsdb Database Name
*/}}
{{- define "supaplus.analyticsdb.database.name" -}}
{{- if .Values.analyticsdb.enabled -}}
    {{/*
        In the supabase-postgres container the database is hardcoded to postgres following
        what's done in upstream
    */}}
    {{- print "postgres" -}}
{{- else -}}
    {{- print .Values.externalDatabaseAnalyticsdb.database -}}
{{- end -}}
{{- end -}}

{{/*
Return the Analyticsdb PostgreSQL User
*/}}
{{- define "supaplus.analyticsdb.database.user" -}}
{{- if .Values.analyticsdb.enabled }}
    {{- print "supabase_admin" -}}
{{- else -}}
    {{- print .Values.externalDatabaseAnalyticsdb.user -}}
{{- end -}}
{{- end -}}

{{/*
reusable supabase env vars
*/}}
{{- define "supaplus.analyticsdb.database.envvars" }}
- name: PGDATABASE
  value: {{ include "supaplus.analyticsdb.database.name" . | quote }}
- name: PGUSER
  value: {{ include "supaplus.analyticsdb.database.user" . | quote }}
- name: PGPASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "supaplus.analyticsdb.database.secretName" . }}
      key: {{ include "supaplus.analyticsdb.database.passwordKey" . | quote }}
- name: PGHOST
  value: {{ include "supaplus.analyticsdb.database.host" . | quote }}
- name: PGPORT
  value: {{ include "supaplus.analyticsdb.database.port" . | quote }}
{{- end -}}

{{/*
reusable db check-db-ready
*/}}
{{- define "supaplus.analyticsdb.database.checkdbready" }}
- name: check-analyticsdb-db-ready
  image: postgres:16
  command: ['sh', '-c',
    'until psql -c "select 1;";
    do echo waiting for database; sleep 2; done;']
  env:
    {{ include "supaplus.analyticsdb.database.envvars" . | indent 4 }}
{{- end -}}

{{/*
Retrieve key of the Analyticsdb postgresql secret
*/}}
{{- define "supaplus.analyticsdb.database.passwordKey" -}}
{{- if .Values.analyticsdb.enabled -}}
    {{- print "postgres-password" -}}
{{- else -}}
    {{- if .Values.externalDatabaseAnalyticsdb.existingSecret -}}
        {{- if .Values.externalDatabaseAnalyticsdb.existingSecretPasswordKey -}}
            {{- printf "%s" .Values.externalDatabaseAnalyticsdb.existingSecretPasswordKey -}}
        {{- else -}}
            {{- print "db-password" -}}
        {{- end -}}
    {{- else -}}
        {{- print "db-password" -}}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
analytics (logflare) credential secret name.
*/}}
{{- define "supaplus.analytics.secretName" -}}
{{- coalesce .Values.analytics.existingSecret "supaplus-logflare" -}}
{{- end -}}

{{/*
analytics (logflare) credential api secret key
*/}}
{{- define "supaplus.analytics.apiSecretKey" -}}
{{- if and .Values.analytics.existingSecret .Values.analytics.existingSecretApiKey -}}
  {{- print .Values.analytics.existingSecretApiKey -}}
{{- else -}}
  {{- print "api-key" -}}
{{- end -}}
{{- end -}}
