#!/usr/bin/python3
#
from __future__ import annotations

import asyncio
import sys
import os
from datetime import datetime
import random
from pathlib import Path
import tarfile


SMALL_GEN_TIME_INTEVAL = 10
LARGE_GEN_TIME_INTEVAL = 5 * 60
words = [
    "timber",
    "kettle",
    "particular",
    "safe",
    "outline",
    "negotiation",
    "wound",
    "artist",
    "rib",
    "weakness",
    "lace",
    "aloof",
    "distribute",
    "offset",
    "unfair",
    "qualified",
    "silence",
    "unlike",
    "witch",
    "consideration",
    "treatment",
    "whip",
    "emergency",
    "jest",
    "reproduce",
    "discriminate",
    "venture",
    "remedy",
    "log",
    "precede",
    "pudding",
    "push",
]


def get_n_random_words(n: int) -> str:
    return " ".join(random.choices(words, k=n))


def create_random_file(path: str):
    num_of_words = random.randint(10, 100)
    random_permissions = random.randint(0, 0o777)

    with open(path, "w") as rand_file:
        rand_file.write(get_n_random_words(num_of_words))

    os.chmod(path, random_permissions)


async def generate_small(dst_path: str):
    # generates one file in the dst_path with random set of permissions
    # also randomly appends some text to the one text file
    fileno = 0
    dst_path = Path(dst_path)

    while True:
        filename = datetime.now().strftime(f"small{fileno}_%d-%m_%H:%M:%S")
        fileno += 1
        create_random_file(dst_path / filename)
        await asyncio.sleep(SMALL_GEN_TIME_INTEVAL)


async def generate_large(dst_path: str):
    # Generates directory with 2 to 10 random small files,
    # then it is merged by the __tar__ algorithm.
    # Also changes permissions of 2 to 10 random files
    # and appends some text to them.
    dirno = 0
    dst_path = Path(dst_path)

    while True:
        dirname = datetime.now().strftime(f"small{dirno}_%d-%m_%H:%M:%S.tar")
        tar = tarfile.open(dst_path / dirname, "w")
        dirno += 1

        for i in range(random.randint(1,8)):
            filename = dst_path / f"file{i}"
            create_random_file(filename)
            os.chmod(filename, 0o777)

            tar.add(filename)
            os.remove(filename)

        tar.close()
        await asyncio.sleep(LARGE_GEN_TIME_INTEVAL)


async def main(dst:str):
    print(f"STARTING CREATING RANDOM FILES ({datetime.now()})")
    await asyncio.gather(generate_small(dst), generate_large(dst))


if __name__ == "__main__":
    dst = sys.argv[1]

    assert os.path.exists(
        dst
    ), f"Cannot write to a directory {dst} because it does not exist!"

    asyncio.run(main(dst))
