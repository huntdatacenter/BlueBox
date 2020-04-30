# Best practice

Remember to check paths in your code. If you are using absolute paths you can hit issues when Bluebox
installs packages differently. Such case could happen with conda packages which are installed in `/home/ubuntu/miniconda3/bin` 
(e.g.: `/home/ubuntu/miniconda3/bin/bcftools`).

If you placed your local script into code `code/analysis.py` it will be placed on path `/home/ubuntu/bluebox/analysis.py` 
and your working directory will be `/home/ubuntu/bluebox`, therefore you can either call it like `python3 analysis.py` 
or with absolute path `python3 /home/ubuntu/bluebox/analysis.py`.

Correct your inputs, e.g. `data/my-input-file` (absolute: `/home/ubuntu/bluebox/data/my-input-file`).

Correct output results, e.g. `results/my-result-file` (absolute: `results/my-result-file`).

Running analysis unattached, example:
```
nohup setsuid make run
```
