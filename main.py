import logging
import time
import sched

s = sched.scheduler(time.time, time.sleep)
logger = logging.getLogger(__name__)

def run_command(sc): 
    print("Doing stuff...")
    # do your stuff
    s.enter(60, 1, run_command, (sc,))

if __name__ == "__main__":
    s.enter(60, 1, run_command, (s,))
    s.run()

