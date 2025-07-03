# React Frontend Helm App

This directory contains a simple React application packaged as a Helm chart for deployment to EKS.

## Structure
- `app/` - React application source code
- `chart/` - Helm chart for Kubernetes deployment

## Usage
1. Build the React app: `npm run build`
2. Package and deploy the Helm chart to your EKS cluster

---

This app is intended to be deployed via a dedicated GitHub Actions workflow.
