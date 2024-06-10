{{/* vim: set filetype=mustache: */}}

{{/*
reusable supabase db env vars
*/}}
{{- define "supabase.database.envvars" }}
- name: DB_USER
  value: {{ include "supabase.database.user" . | quote }}
- name: DB_HOST
  value: {{ include "supabase.database.host" . | quote }}
- name: DB_PORT
  value: {{ include "supabase.database.port" . | quote }}
- name: DB_NAME
  value: {{ include "supabase.database.name" . | quote }}
- name: DB_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "supabase.database.secretName" . }}
      key: {{ include "supabase.database.passwordKey" . | quote }}
- name: DB_SSL
  value: {{ .Values.dbSSL | quote }}
{{- end -}}

{{/*
reusable supabase env vars
*/}}
{{- define "supabase.database.pgenvvars" }}
- name: PGDATABASE
  value: {{ include "supabase.database.name" . | quote }}
- name: PGUSER
  value: {{ include "supabase.database.user" . | quote }}
- name: PGPASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "supabase.database.secretName" . }}
      key: {{ include "supabase.database.passwordKey" . | quote }}
- name: PGHOST
  value: {{ include "supabase.database.host" . | quote }}
- name: PGPORT
  value: {{ include "supabase.database.port" . | quote }}
{{- end -}}

{{/*
reusable db check-db-ready
*/}}
{{- define "supabase.database.checkdbready" }}
- name: check-supabase-db-ready
  image: postgres:16
  command: ['sh', '-c',
    'until psql -c "select 1;";
    do echo waiting for database; sleep 2; done;']
  env:
    {{ include "supabase.database.pgenvvars" . | indent 4 }}
{{- end -}}

{{/*
Return postgresql Analyticsdb fullname
*/}}
{{- define "supabase.analyticsdb.database.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "analyticsdb" "chartValues" .Values.analyticsdb "context" $) -}}
{{- end -}}

{{/*
Return the PostgreSQL Analyticsdb Hostname
*/}}
{{- define "supabase.analyticsdb.database.host" -}}
{{- if .Values.analyticsdb.enabled -}}
    {{- if eq .Values.analyticsdb.architecture "replication" -}}
        {{- printf "%s-%s" (include "supabase.analyticsdb.database.fullname" .) "primary" | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
        {{- print (include "supabase.analyticsdb.database.fullname" .) -}}
    {{- end -}}
{{- else -}}
    {{- print .Values.externalDatabaseAnalyticsdb.host -}}
{{- end -}}
{{- end -}}

{{/*
Return postgresql Analyticsdb port
*/}}
{{- define "supabase.analyticsdb.database.port" -}}
{{- if .Values.analyticsdb.enabled -}}
    {{- print .Values.analyticsdb.service.ports.postgresql -}}
{{- else -}}
    {{- print .Values.externalDatabaseAnalyticsdb.port  -}}
{{- end -}}
{{- end -}}

{{/*
Return the PostgreSQL Analyticsdb Secret Name
*/}}
{{- define "supabase.analyticsdb.database.secretName" -}}
{{- if .Values.analyticsdb.enabled -}}
    {{- if .Values.analyticsdb.auth.existingSecret -}}
    {{- print .Values.analyticsdb.auth.existingSecret -}}
    {{- else -}}
    {{- print (include "supabase.analyticsdb.database.fullname" .) -}}
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
{{- define "supabase.analyticsdb.database.name" -}}
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
{{- define "supabase.analyticsdb.database.user" -}}
{{- if .Values.analyticsdb.enabled }}
    {{- print "supabase_admin" -}}
{{- else -}}
    {{- print .Values.externalDatabaseAnalyticsdb.user -}}
{{- end -}}
{{- end -}}

{{/*
reusable supabase env vars
*/}}
{{- define "supabase.analyticsdb.database.envvars" }}
- name: PGDATABASE
  value: {{ include "supabase.analyticsdb.database.name" . | quote }}
- name: PGUSER
  value: {{ include "supabase.analyticsdb.database.user" . | quote }}
- name: PGPASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "supabase.analyticsdb.database.secretName" . }}
      key: {{ include "supabase.analyticsdb.database.passwordKey" . | quote }}
- name: PGHOST
  value: {{ include "supabase.analyticsdb.database.host" . | quote }}
- name: PGPORT
  value: {{ include "supabase.analyticsdb.database.port" . | quote }}
{{- end -}}

{{/*
reusable db check-db-ready
*/}}
{{- define "supabase.analyticsdb.database.checkdbready" }}
- name: check-analyticsdb-db-ready
  image: postgres:16
  command: ['sh', '-c',
    'until psql -c "select 1;";
    do echo waiting for database; sleep 2; done;']
  env:
    {{ include "supabase.analyticsdb.database.envvars" . | indent 4 }}
{{- end -}}

{{/*
Retrieve key of the Analyticsdb postgresql secret
*/}}
{{- define "supabase.analyticsdb.database.passwordKey" -}}
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
