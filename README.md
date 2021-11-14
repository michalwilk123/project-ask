# Project - Computer System Administration

Project assignment from University. Creating various backups in Linux OS.
The project consists of the docker image running Ubuntu 20 LTS Focal and
a bash script capable of:
- creating full backups
- creating incremental backups
- restoring the data
- keeping track of old data and automatically deleting it

---

## How to run project

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
python3 test_app.py /app/app_data
```

---

## How to use the script

### Available options:
* **install** - installs the backup script (also automatically sets up the cron job)
* **incremental | inc** - create incremental backup
* **weekly** - create weekly backup of whole data
* **restore | rst** - restore the data to the previous state
* **del | delete** - deletes the files too old to be tracked (deletes only full backups)

#### 1) install _PATH_TO_DIRECTORY_WITH_DATA_ _PATH_TO_DIRECTORY_WITH_BACKUPS_ _LOG_FILE_DIRECTORY[optional]_

``` bash
/app/ask_backup.sh install /app/app_data /app/backups /var/log/ask_backup.log
```
Initiates the script. Prepares the git repository that tracks the changes in the data directory. 
Command aldo sets up the cronjob with opinionated dates when the backups should be performed.

**Default log location:** _/var/log/ask_backup.log_

#### 2) inc _PATH_TO_DIRECTORY_WITH_DATA_ _PATH_TO_DIRECTORY_WITH_BACKUPS_

``` bash
/app/ask_backup.sh inc /app/app_data/ /app/backups/
```
Creates the incremental backup of the files in the folder provided in the first argument.
The backup is performed by creating new branch in detached git repository created at location:
_YOUR_BACKUP_PATH/**inc.git**_

Git cannot handle permissions and ownership data of the files. We solved this problem by dynamically
generating the script which takes care of all this precious metadata. This script is also tracked so we can see 
what metadata existed in history.

#### 3) weekly _PATH_TO_DIRECTORY_WITH_DATA_ _PATH_TO_DIRECTORY_WITH_BACKUPS_
``` bash
/app/ask_backup.sh weekly /app/app_data/ /app/backups/
```
Creates full backup of the data folder. The files are merged into a tarball and gzipped into singular file
with date in the filename.

#### 4) delete _PATH_TO_DIRECTORY_WITH_DATA_ _PATH_TO_DIRECTORY_WITH_BACKUPS_
``` bash
/app/ask_backup.sh delete /app/app_data/ /app/backups/
```

Deletes all older backups from certain date.

#### 5) restore _PATH_TO_DIRECTORY_WITH_DATA_ _PATH_TO_DIRECTORY_WITH_BACKUPS_
Restore the state of the data folder. Can choose couple of diffrent snapshots (incremental).
Cannot restore the incremental snapshots of older full backups.


