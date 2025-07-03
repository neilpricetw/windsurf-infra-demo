{{/* Define common template helpers for this chart */}}
{{- define "react-frontend.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "react-frontend.name" -}}
{{- .Chart.Name -}}
{{- end -}}
