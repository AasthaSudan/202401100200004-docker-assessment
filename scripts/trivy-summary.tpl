{{- range . }}
{{ .Target }}
{{- $critical := 0 }}{{- $high := 0 }}{{- $medium := 0 }}{{- $low := 0 }}
{{- range .Vulnerabilities }}
{{- if eq .Severity "CRITICAL" }}{{- $critical = add $critical 1 }}{{- end }}
{{- if eq .Severity "HIGH" }}{{- $high = add $high 1 }}{{- end }}
{{- if eq .Severity "MEDIUM" }}{{- $medium = add $medium 1 }}{{- end }}
{{- if eq .Severity "LOW" }}{{- $low = add $low 1 }}{{- end }}
{{- end }}
CRITICAL={{ $critical }} HIGH={{ $high }} MEDIUM={{ $medium }} LOW={{ $low }}
{{ end -}}
