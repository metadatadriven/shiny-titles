#!/bin/bash
curl -X POST "https://demo2.dominodatalab.com/v4/jobs/start" \
     -H  "accept: application/json" \
     -H  "X-Domino-Api-Key: af05a6b443daa1fab20b5713f5657977f9d376e23e6efe6e3e061c70258fee6b" \
     -H  "Content-Type: application/json" -d "{\"projectId\":\"638f026834e24c3be154979f\",\"commandToRun\":\"python-code/pdf-generator.py\",\"title\":\"Metadata Triggered Execution using Domino API\"}"