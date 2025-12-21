# Commandes essentielles Docker Compose

---

Cycle de vie

```
docker compose up
```

Lance les services au premier plan.

```
docker compose up -d
```

Lance en arrière plan.

```
docker compose down
```

Stoppe et supprime conteneurs, réseau par défaut.

```
docker compose down -v
```

Supprime aussi les volumes.

```
docker compose stop
```

Stoppe sans supprimer.

```
docker compose start
```

Redémarre des services stoppés.

```
docker compose restart
```

Restart complet.

---

Build et images

```
docker compose build
```

Construit les images.

```
docker compose build --no-cache
```

Rebuild propre.

```
docker compose pull
```

Récupère les images distantes.

---

Statut et inspection

```
docker compose ps
```

État des services.

```
docker compose config
```

Affiche la config finale après merge et résolution.

```
docker compose ls
```

Liste les projets compose actifs.

---

Logs et debug

```
docker compose logs
```

Tous les logs.

```
docker compose logs -f
```

Suivi temps réel.

```
docker compose logs nginx
```

Logs d’un service précis.

---

Exécution dans un conteneur

```
docker compose exec wordpress sh
```

Shell dans un conteneur en cours.

```
docker compose exec mariadb mysql -u root -p
```

Commande directe.

```
docker compose run wordpress bash
```

Lance un conteneur ponctuel.

---

Réseau et dépendances

```
docker compose top
```

Process actifs par service.

```
docker compose events
```

Événements Docker en temps réel.

```
docker compose port nginx 80
```

Mapping de ports effectif.

---

Nettoyage global utile

```
docker system prune
```

Nettoyage large.

```
docker volume prune
```

Volumes orphelins.

```
docker network prune
```

Réseaux inutilisés.

---

Variables et profils

```
docker compose --env-file .env up
```

Charge variables.

```
docker compose --profile dev up
```

Lance un profil spécifique.

---

Résumé mental à retenir

* up down restart
* logs exec ps
* build pull
* down -v = reset total
* exec pour debug
* config pour comprendre ce qui est vraiment lancé


---

![Image](https://assets.bytebytego.com/diagrams/0414-how-does-docker-work.png?utm_source=chatgpt.com)

![Image](https://www.docker.com/app/uploads/2021/11/docker-containerized-and-vm-transparent-bg.png?utm_source=chatgpt.com)

![Image](https://docs.docker.com/compose/images/compose-application.webp?utm_source=chatgpt.com)

## Docker and Docker Compose 101

### Core mental model

* **Docker** packages software plus dependencies into immutable artifacts.
* **Image** equals blueprint.
* **Container** equals running instance of an image.
* **Docker Compose** equals orchestrator for multiple containers on one machine.

### Image

* Built from a **Dockerfile**.
* Read-only layers stacked.
* Versioned by tag.
* Portable. Same image everywhere.

Key facts:

* Images do nothing by themselves.
* One image can spawn many containers.
* Rebuilt when Dockerfile or build context changes.

### Container

* Runtime of an image.
* Has PID, filesystem overlay, network interface.
* Ephemeral by default.

Key facts:

* Deleting a container deletes its data unless volumes are used.
* Restarting a container does not rebuild the image.
* Containers are isolated but share the host kernel.

### Dockerfile

Instruction list to build an image.

Canonical structure:

```
FROM base_image
RUN install stuff
COPY files
WORKDIR /app
EXPOSE port
CMD or ENTRYPOINT
```

Critical distinctions:

* **RUN** executes at build time.
* **CMD / ENTRYPOINT** execute at runtime.
* Only the last CMD is effective.
* EXPOSE is documentation, not networking.

### docker run

Low-level runtime command.

What it does:

* Creates container
* Attaches filesystem
* Sets network
* Executes CMD

Common flags:

* `-d` detached
* `-p host:container` port mapping
* `-v host:container` volume mount
* `--name` explicit container name
* `--rm` auto-delete on stop

Without Compose, you wire everything manually.

### Volumes

Persistent storage.

Types:

* **Named volume** managed by Docker.
* **Bind mount** maps host path.

Rules:

* Containers are stateless.
* Databases require volumes.
* Volumes outlive containers.
* Images never store runtime data.

### Networks

Virtual L2/L3 networks.

Rules:

* Containers in same network resolve each other by name.
* Each Compose project creates a default bridge.
* Exposed ports are internal only.
* Published ports are host-accessible.

### Docker Compose

YAML-based multi-container definition.

What it adds:

* Service abstraction
* Automatic networks
* Ordered startup
* Shared environment
* One-command lifecycle

Compose is not Kubernetes. Single-host only.

### docker-compose.yml mental model

* **services** equals containers
* **volumes** equals persistent storage
* **networks** equals connectivity

Typical stack:

* nginx
* app
* database

Service names become DNS hostnames.

### build vs image

* `build:` means Dockerfile is used.
* `image:` means pull or reuse existing image.
* Build happens once, containers many times.

### Lifecycle commands

* `docker compose up` create and start
* `docker compose up --build` rebuild images
* `docker compose down` stop and remove containers
* `docker compose down -v` also remove volumes
* `docker compose logs` aggregated logs
* `docker compose exec` shell into running container

### Restart behavior

* Containers restart based on policy.
* Images never restart.
* Volumes persist unless explicitly removed.

### Ports vs expose

* `expose` internal documentation.
* `ports` binds container port to host.
* In Compose, expose is rarely needed.

### ENV and secrets

* ENV baked at runtime, not build.
* `.env` file injects variables.
* Secrets are not encrypted by default.
* Never hardcode secrets in Dockerfile.

### CMD vs ENTRYPOINT

* CMD is default command.
* ENTRYPOINT is the executable.
* ENTRYPOINT plus CMD equals final argv.
* ENTRYPOINT is harder to override.

### Debugging basics

* `docker ps` running containers
* `docker images`
* `docker logs`
* `docker exec -it container sh`
* `docker inspect` ground truth

### What Docker is not

* Not a VM.
* Not a security boundary.
* Not a replacement for orchestration at scale.
* Not persistent by default.

### How to sound competent

* Say containers are ephemeral.
* Say images are immutable.
* Say state lives in volumes.
* Say Compose is for local and small prod.
* Say Kubernetes solves multi-host orchestration.
* Say rebuild when Dockerfile changes.
* Say restart does not rebuild.

This is the complete mental map.
