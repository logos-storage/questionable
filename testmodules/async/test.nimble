version = "0.1.0"
author = "Questionable Authors"
description = "Questionable tests for pkg/chronos"
license = "MIT"

requires "chronos >= 4.2.2"
requires "asynctest >= 0.5.4"

let nimBin = getEnv("NIM_PATH", "nim")

when (NimMajor, NimMinor) >= (1, 6):
  task test, "Runs the test suite":
    exec nimBin & " c -f -r --skipParentCfg --nimcache:./nimcache test.nim"
else:
  task test, "Runs the test suite":
    echo "Warning: Skipping test with chronos on Nim < 1.6"
