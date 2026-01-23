# How to Patch Vulnerable Workload
#####################
scan the image that is used by the deployment and verify if the container contains vulnerable dependencies. 
Review the SBOM and identify any known vulnerable packages (e.g., outdated OpenSSL, curl, etc).

# example
trivy image python:3.14.1-alpine3.22 ( vulnerabilities are found )
trivy image python:3.14.1-alpine3.22 --scanners vuln --format cyclonedx --output /tmp/alpine-3222.json

trivy image python:3.14.1-alpine3.23 ( no vulnerabilities )
trivy image python:3.14.1-alpine3.23 --scanners vuln --format cyclonedx --output /tmp/alpine-3232.json

# cat alpine-3232.json | grep -A 3 vulnerabilities
  "vulnerabilities": []
}

# cat alpine-3222.json | grep -A 2 vulnerabilities
  "vulnerabilities": [
    {
      "id": "CVE-2024-58251",
