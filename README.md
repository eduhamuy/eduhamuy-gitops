# eduhamuy-gitops

GitOps repository for the EduHamuy platform.

## Purpose

This repository contains the declarative configuration used to deploy and manage EduHamuy workloads across Kubernetes environments.

## Environments

- DEV
- TEST
- STAGE
- PROD

## Application

- `eduhamuy-web`
- `eduhamuy-ai`

## GitOps

Argo CD will be used to continuously reconcile the Kubernetes desired state defined in this repository with the runtime environment.

## Container Registry

Application images are published to GitHub Container Registry (GHCR).

Example:

`ghcr.io/eduhamuy/eduhamuy-web:<tag>`
