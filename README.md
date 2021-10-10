# Project - Computer System Administration
Project assignment from University. Creating various backups in Linux OS

---

The project consists of the docker image running Ubuntu 20 LTS Focal and
various bash scripts for:

- **generating test files**:
  - generators/generate-files-large.sh
  - generators/generate-files-small.sh
- **creating backups**:
  - backup-scripts/inc-backup.sh
  - backup-scripts/weekly-backup.sh
  - backup-scripts/inc-backup.sh
- **deleting old backups**:
  - backup-scripts/delete-old-backups.sh

---

### How to run project

1. Clone the git repository
```bash
git  clone https://github.com/michalwilk123/project-ask
```
2. Build the docker image (while in the _project-ask_ directory!)
```bash
docker build --tag ask-inf .
```
3. Run the docker image

You can also test out all the scripts by running bash shell inside the docker
container (quick reminder: docker container is a **RUNNING** docker image,
so it is nessesary to perform the operation no. **3** for this operation to
be successful)

```bash
docker run ask-inf:latest
```
