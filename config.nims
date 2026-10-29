# Style Check
if (NimMajor, NimMinor, NimPatch) >= (1, 6, 6):
  --styleCheck:usages
if (NimMajor, NimMinor) < (1, 6):
  --styleCheck:hint
else:
  --styleCheck:error

# Disable some warnings
if (NimMajor, NimMinor) >= (1, 6):
  switch("warning", "DotLikeOps:off")
