function open-current-job
	if not set -q LUCA_WORK_DIR
        echo "set LUCA_WORK_DIR globally before running: set -Ux LUCA_WORK_DIR <directory>"
        exit
    end
    if not set -q CURRENT_JOB
        echo "set CURRENT_JOB globally before running: set -Ux CURRENT_JOB <job>"
        exit
    end
    cd $LUCA_WORK_DIR/engagement-files/$CURRENT_JOB
    if test $status -ne 0
        echo "Failed to open the current job directory. Please make sure directory exists:"
        echo "$LUCA_WORK_DIR/engagement-files/$CURRENT_JOB"
    end
end
