# Cinema - Example of Microservices in Go with Docker, Kubernetes and MongoDB

## Overview

Cinema is an example project which demonstrates the use of microservices for a fictional movie theater.
The Cinema backend is powered by 4 microservices, all of which happen to be written in Go, using MongoDB for manage the database and Docker to isolate and deploy the ecosystem.

 * Movie Service: Provides information like movie ratings, title, etc.
 * Show Times Service: Provides show times information.
 * Booking Service: Provides booking information.
 * Users Service: Provides movie suggestions for users by communicating with other services.

The Cinema use case is based on the project written in Python by [Umer Mansoor](https://github.com/umermansoor/microservices).

The project structure is based in the knowledge learned in:

* Golang structure: <https://peter.bourgon.org/go-best-practices-2016/#repository-structure>
* Book Let's Go: <https://lets-go.alexedwards.net/>

## Index

* [Manual Steps for GCP/Do](#cloud-providers)
* [Deployment](#deployment)
* [How To Use Cinema Services](#how-to-use-cinema-services)
* [Related Posts](related-posts)
* [Significant Revisions](#significant-revisions)
* [The big picture](#screenshots)

## Cloud Providers

* GCP: Configure OIDC OAuth2 Consent Screen and credentials token for ArgoCD (see: https://argo-cd.readthedocs.io/en/stable/operator-manual/user-management/google/)
* GCP: Run examples/oidc-simple on local machine, or once as part of CICD initialization pipeline, with changes noted at https://github.com/autotune/terraform-google-github-actions-runners/pull/1/files
* GitHub: fork into your own repo and run release.yml workflow 
* Configure required secrets for repo (mentioned below)
  - secret1
  - secret2
  - secret3 
* Partner with company like fotc.com, Contino, 2nd Watch, etc. to raise regional limits needed for 4x e2-standard-4 GKE instances minimum 

## Deployment

The application can be deployed in both environments: **local machine** or in a **kubernetes cluster**. You can find the appropriate documentation for each case in the following links:

* [local machine (docker compose)](./docs/localhost.md)
* [kubernetes](./docs/kubernetes.md)

## How To Use Cinema Services

* [endpoints](./docs/endpoints.md)

## Related Posts

* [Traefik 2 - Advanced configuration with Docker Compose](https://mmorejon.io/en/blog/traefik-2-advanced-configuration-docker-compose/)

## Significant Revisions

* [Microservices - Martin Fowler](http://martinfowler.com/articles/microservices.html)
* [Umer Mansoor - Cinema](https://github.com/umermansoor/microservices)
* [Traefik Proxy Docs](https://doc.traefik.io/traefik/)
* [MongoDB Driver for Golang](https://github.com/mongodb/mongo-go-driver)
* [MongoDB Golang Channel](https://www.youtube.com/c/MongoDBofficial/search?query=golang)

## Screenshots

### Architecture

![overview](docs/images/overview.jpg)

### Homepage

![website home page](docs/images/website-home.jpg)

### Users List

![users list page](docs/images/website-users.jpg)
