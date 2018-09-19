# submit
A wrapper for submitting jobs to a SGE cluster

##Usage:
    submit.pl  [options]  job1.sh [job2.sh [...]]
##Options:
    -b      treat JOB as binary instead of script

    -m STR  submit to compute nodes with available memory in Gb [10]

    -n INT  submit to compute nodes with available CPU [1]

    -q STR  submit to queue {short,medium,long,ionode}.q

    -H STR  time limit of the job in hours [240]

    -N STR  the name of the job [SCRIPT_NAME]

    -W STR  Execute the job from the specified directory [CURRENT_DIR]

    -o STR  other parameters pass to qsub, e.g.
            '-t 1-38' for array jobs (use $SGE_TASK_ID in your job script) [null]

    -p      just print the qsub command without running

    -h      print this help

## Authors

* [Hechuan Yang](https://github.com/hchyang)

## License

This project is licensed under the GNU GPLv3 License - see the 
[LICENSE](LICENSE) file for details.

