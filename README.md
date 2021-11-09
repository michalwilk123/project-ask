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
- **deleting old backups**:
  - backup-scripts/delete-old-backups.sh
- **restoring state from backups**:
  - backup-scripts/restore.sh

---

### How to run project

1. Clone the git repository
```bash
git clone https://github.com/michalwilk123/project-ask
```

2. Build the docker image (while in the _project-ask_ directory!)
```bash
docker build --tag ask-inf .
```

3. Run the docker image and open bash shell 
```bash
docker run -it ask-inf:latest
```

4. Install some things (unnecessary)
```bash
./install.sh
```

5. Run the demo app showcasing the utilites of the script
```bash
python3 test_app.py app_data
```
