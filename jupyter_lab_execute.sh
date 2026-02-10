#!/bin/bash

# Get target user from argument, default to current user if not provided
TARGET_USER="${1:-$USER}"

run_jupyter() {
    local USER_NAME="$1"
    # Forcefully define HOME_DIR to avoid $HOME variable confusion when using sudo
    local HOME_DIR="/home/${USER_NAME}"
    local WORK_DIR="${HOME_DIR}/JupyterLAB"
    # Extract the primary IP address of the cluster
    local CLUSTER_NAME=$(hostname -I | awk '{print $1}')

    echo "Setting up for ${USER_NAME} in ${HOME_DIR}..."

    # Check if the virtual environment exists in the target directory
    if [ -d "${WORK_DIR}/bin" ]; then
        # Generate a random port between 8000 and 9999
        local PORT=$(shuf -i 8000-9999 -n 1)
        local NODE="localhost"
        local INFOFILE="${WORK_DIR}/jupyter_info_${PORT}.txt"

        # Create the connection info file
        {
            echo "Node: $(hostname)"
            echo "Port: $PORT"
            echo "To connect:"
            echo "=== terminal : ssh tunneling ==="
            # SSH command using port 7540 as requested
            echo "ssh -p 7540 -N -L ${PORT}:${NODE}:${PORT} ${USER_NAME}@${CLUSTER_NAME}"
            echo "=== local web browser information ==="
            echo "localhost:$PORT"
        } > "$INFOFILE"

        # Change ownership of the info file to the target user (in case script is run by root)
        chown ${USER_NAME}:${USER_NAME} "$INFOFILE" 2>/dev/null

        echo "Starting Jupyter as ${USER_NAME}..."

        # Execute Jupyter Lab as the target user to ensure correct permissions and environment
        # - 'runuser -l' logs in as the user, loading their specific environment variables
        runuser -l ${USER_NAME} -c "
            cd ${WORK_DIR} && \
            source bin/activate && \
            nohup timeout 12h jupyter lab \
                --no-browser \
                --ip=0.0.0.0 \
                --port=${PORT} \
                --config=${HOME_DIR}/.jupyter/jupyter_server_config.json \
                > jupyter.log 2>&1 &
        "

        echo "------------------------------------------------"
        echo "Jupyter Lab is starting on port ${PORT}"
        echo "Check connection info: cat ${INFOFILE}"
        echo "------------------------------------------------"
    else
        echo "Error: Virtual environment not found in ${WORK_DIR}"
        echo "Please ensure the venv is installed at ${WORK_DIR}"
    fi
}

# Execute the function
run_jupyter "$TARGET_USER"