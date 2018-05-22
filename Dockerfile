# escape=`

# Build off .NET Core Server container
FROM microsoft/windowsservercore:latest

LABEL maintainer="Campbell Gunn <campbelldgunn@gmail.com>" `
      org.label-schema.schema-version="v1.10.2" `
      org.label-schema.name="Windows Kubectl Client"

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ARG VCS_REF
ARG BUILD_DATE

# Metadata
LABEL org.label-schema.vcs-ref=$VCS_REF `
      org.label-schema.vcs-url="https://github.com/campbelldgunn/k8s-kubectl-windows" `
      org.label-schema.build-date=$BUILD_DATE
      
ENV KUBE_LATEST_VERSION="v1.10.2"

RUN mkdir 'C:\Program Files\kubectl'

RUN Invoke-WebRequest ""https://storage.googleapis.com/kubernetes-release/release/$env:KUBE_LATEST_VERSION/bin/windows/amd64/kubectl.exe"" ""-OutFile 'C:\Program Files\kubectl\kubectl.exe'""

COPY Set-PathVariable.ps1 .\Set-PathVariable.ps1

RUN .\Set-PathVariable.ps1 -NewLocation 'C:\Program Files\kubectl'

ENTRYPOINT powershell 'kubectl.exe'
