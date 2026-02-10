#!/bin/bash

# Target user is the current user ($USER)
TARGET_USER="$USER"

run_jupyter() {
    local USER_NAME="$TARGET_USER"
    local HOME_DIR="/home/${USER_NAME}"
    local WORK_DIR="${HOME_DIR}/JupyterLAB"
    local CLUSTER_NAME=$(hostname -I | awk '{print $1}')

    echo "Setting up for ${USER_NAME}..."

    # Check for virtual environment
    if [ -d "${WORK_DIR}/bin" ]; then
        local PORT=$(shuf -i 8000-9999 -n 1)  # Using your attempted port
        local INFOFILE="${WORK_DIR}/jupyter_info_${PORT}.txt"

        echo "Starting Jupyter..."

        # 1. Move to workspace
        cd "${WORK_DIR}" || exit

        # 2. Activate venv and run Jupyter directly
        # We use 'bash -c' to ensure the environment is loaded correctly without needing root
        nohup bash -c "
            source bin/activate && \
            jupyter lab \
                --no-browser \
                --ip=0.0.0.0 \
                --port=${PORT} \
                --config=${HOME_DIR}/.jupyter/jupyter_server_config.json \
        " > jupyter.log 2>&1 &

        # 3. Save connection info
        {
            echo "Port: $PORT"
            echo "SSH Tunnel Command:"
            echo "ssh -p 7540 -N -L ${PORT}:localhost:${PORT} ${USER_NAME}@${CLUSTER_NAME}"
        } > "$INFOFILE"

        echo "------------------------------------------------"
        echo "Jupyter Lab process started."
        echo "Check log: cat ${WORK_DIR}/jupyter.log"
        echo "------------------------------------------------"
    else
        echo "Error: Virtual environment not found in ${WORK_DIR}"
    fi
}

run_jupyter