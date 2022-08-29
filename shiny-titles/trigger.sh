#!/bin/bash
curl -X POST "https://se-sandbox.domino-eval.com/v4/jobs/start" \
     -H  "accept: application/json" \
     -H  "X-Domino-Api-Key: 16c22313dd5f14d961595f6b7855b2a8312fa2b010bd51b303fe9959a982fdec" \
     -H  "Content-Type: application/json" -d "{\"projectId\":\"6308d5c9c92bbb395372f3dd\",\"commandToRun\":\"python-code/pdf-generator.py\",\"title\":\"Metadata Triggered Execution using Domino API\"}"
