#!/bin/bash
set -eo pipefail
rm -rf aws-logging-layer/nodejs/node-modules aws-logging-layer/nodejs/package-lock.json
cd aws-logging-layer/nodejs
npm install