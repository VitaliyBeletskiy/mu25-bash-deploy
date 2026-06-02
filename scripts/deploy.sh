#!/bin/bash
SSH_FILE="$HOME/.ssh/awc-ec2-ssh-key.pem"
SERVER_USER="ubuntu"
SERVER_HOST="16.192.40.103"

APP_DIR="/opt/bash-demo"
JAR_NAME="bash-demo-app.jar"
SERVICE_NAME="bash-demo"

# Navigate to the project root directory in order to execute gradle commands
cd "$(dirname "$0")/.." || exit 1

build() {
  # Build jar file
  ./gradlew bootJar
  # File is located at build/libs/bash-demo-<x>.<x>.<x>-SNAPSHOT.jar
}

LOCAL_JAR=$(ls build/libs/*.jar | head -n 1)
if [ -z "${LOCAL_JAR}" ]; then
  echo "Error: Jar file not found. Please build the project first."
  exit 1
fi
echo "File ${LOCAL_JAR} has been built successfully."

upload() {
  # Upload jar file to server to /tmp/bash-demo-app.jar
  scp \
    -i "${SSH_FILE}" \
    -o "StrictHostKeyChecking=no" \
    -o BatchMode=yes \
    -q \
    "${LOCAL_JAR}" \
    "${SERVER_USER}"@"${SERVER_HOST}":/tmp/"${JAR_NAME}"

  if [ $? -ne 0 ]; then
      echo "Error: Upload failed."
      exit 1
  fi

  REMOTE_JAR_FILE=$(ssh \
    -i "${SSH_FILE}" \
    -o "StrictHostKeyChecking=no" \
    -o BatchMode=yes \
    -q \
    "${SERVER_USER}"@"${SERVER_HOST}" \
    "ls -la /tmp/ | grep ${JAR_NAME}")
  if [ -z "${REMOTE_JAR_FILE}" ]; then
    echo "Error: Upload verification failed. JAR file not found on remote server."
    exit 1
  fi
}

replace_jar() {
  ssh \
    -i "${SSH_FILE}" \
    -o "StrictHostKeyChecking=no" \
    -o BatchMode=yes \
    -q \
    "${SERVER_USER}"@"${SERVER_HOST}" \
    "
    if [ ! -d ${APP_DIR} ]; then
      sudo mkdir -p ${APP_DIR}
    fi

    if [ -f ${APP_DIR}/${JAR_NAME} ]; then
      sudo mv ${APP_DIR}/${JAR_NAME} ${APP_DIR}/${JAR_NAME}.previous
    fi

    sudo mv /tmp/${JAR_NAME} ${APP_DIR}/${JAR_NAME}
    "
}

restart_service() {
  echo "Restarting service ${SERVICE_NAME}..."

  ssh \
    -i "${SSH_FILE}" \
    -o "StrictHostKeyChecking=no" \
    -o BatchMode=yes \
    -q \
    "${SERVER_USER}@${SERVER_HOST}" \
    "sudo systemctl restart ${SERVICE_NAME}"

  if [ $? -ne 0 ]; then
    echo "Error: Failed to restart service."
    exit 1
  fi

  echo "Service restarted successfully."
}

build
upload
replace_jar
restart_service