# How to Patch Vulnerable Workload
#####################
scan the image that is used by the deployment and verify if the container contains vulnerable dependencies. 
Review the SBOM and identify any known vulnerable packages (e.g., outdated OpenSSL, curl, etc).

# example
trivy image alpine:3.22.2 ( vulnerabilities are found )
trivy image alpine:3.22.2 --scanners vuln --format cyclonedx --output /tmp/alpine-3222.json

trivy image alpine:3.23.2 ( no vulnerabilities )
trivy image alpine:3.23.2 --scanners vuln --format cyclonedx --output /tmp/alpine-3232.json

# cat alpine-3232.json | grep -A 3 vulnerabilities
  "vulnerabilities": []
}

# cat alpine-3222.json | grep -A 2 vulnerabilities
  "vulnerabilities": [
    {
      "id": "CVE-2024-58251",
