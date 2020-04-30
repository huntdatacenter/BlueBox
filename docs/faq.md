# FAQ

## How can I run analysis unattached?

```
nohup setsuid make run
```

## What to do if make results fail?

- Make sure that you clean your remote results (`make clean`) before running your analysis
- Clean results in your local folder to avoid conflicted files, this is partially handled by adding conflicted suffix to the name of files, but it only handles limited amount of duplicates

## What if my tasks fail?

Try using `make retry` to retry failed or `make resume` to continue with unfinished part of task list.
