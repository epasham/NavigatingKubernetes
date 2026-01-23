# How to Patch Vulnerable Workload
#####################
scan the image that is used by the deployment and verify if the container contains vulnerable dependencies. 
Review the SBOM and identify any known vulnerable packages (e.g., outdated OpenSSL, curl, etc).

STEP-1: Build sample app
cd flask-app
docker build -t ekambaram/sample-app:alpine3.22 .

STEP-2: Deploy sample app
k apply -f sample-app.yaml

# However, it is reported that image used in the deployment is vulnerable. 
# Using Trivy, scan the image that is used by the deployment and verify if the container contains vulnerable dependencies


# Identify the base image used in the deployment and scan the base image
# It is observed that flask-app is built based on the python alpine image ( python:3.14.1-alpine3.23 ) 
trivy image python:3.14.1-alpine3.22

# It is found that the above base image has some vulnerabilities

# export the SBOM document as JSON
trivy image python:3.14.1-alpine3.22 --scanners vuln --format cyclonedx --output /tmp/alpine-3222.json


STEP-3: Let us look at newer base image, say python:3.14.1-alpine3.23
trivy image python:3.14.1-alpine3.23 
trivy image python:3.14.1-alpine3.23 --scanners vuln --format cyclonedx --output /tmp/alpine-3232.json

# cat alpine-3232.json | grep -A 3 vulnerabilities
  "vulnerabilities": []
}

# cat alpine-3222.json | grep -A 2 vulnerabilities
  "vulnerabilities": [
    {
      "id": "CVE-2024-58251",


Image python:3.14.1-alpine3.23 doesnt have vulnerabilities. 


STEP-4: Patch and rebuild the image
vi Dockerfile
FROM python:3.14.1-alpine3.23


# build the image
docker build -t ekambaram/sample-app:alpine3.23 .
docker build -t ekambaram/sample-app:alpine3.23

# edit the deployment manifest and update the image 

