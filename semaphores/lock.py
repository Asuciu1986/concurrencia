#! /usr/bin/env python

import threading
import time

THREADS = 4
MAX_COUNT = 10000000

counter = 0
mutex = threading.RLock()

class myThread(threading.Thread):
    def __init__(self, threadID):
        threading.Thread.__init__(self)
        self.threadID = threadID

    def run(self):
        global counter
        print("Thread {}".format(self.threadID))

        for i in range(MAX_COUNT/THREADS):
            mutex.acquire()
            counter += 1
            mutex.release()


threads = []

for i in range(THREADS):
    # Create new threads
    t = myThread(i)
    threads.append(t)
    t.start() # start the thread

# Wait for all threads to complete
for t in threads:
    t.join()

print("Counter value: %d Expected: %d\n" % (counter, MAX_COUNT))
