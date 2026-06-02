# Java Application Deployment with Bash and EC2

This project was created for the MU25 course, sub-course **Introduction to Linux**.

The goal of the assignment is to create a Bash script that automates the deployment of a Java application to an AWS EC2 instance.

## Assignment

For the VG grade level, the Bash script must automate the following CI/CD-style deployment pipeline:

1. Build the JAR file locally
2. Copy the JAR file to an EC2 instance using SCP
3. Connect to the EC2 instance using SSH
4. Replace the old JAR file on the server
5. Restart the application service

## Project Description

This repository contains a simple Spring Boot application and a Bash deployment script.

The Spring Boot application exposes one GET endpoint that returns the current application version. This makes it easy to verify that a new version has been successfully deployed to the EC2 server.

## Technologies Used

* Java 17
* Spring Boot
* Bash
* SSH
* SCP
* AWS EC2
* systemd

## Application Endpoint

The application provides one simple endpoint:

```http
GET /version
```

Example response:

```text
Version: 1.0.0
```

After deployment, the endpoint can be used to verify that the application is running on the EC2 instance.

## Deployment Script

The deployment script is located in:

```text
scripts/deploy.sh
```

The script performs the following steps:

```text
Build local JAR
        ↓
Copy JAR to EC2 using SCP
        ↓
SSH into EC2
        ↓
Replace old JAR
        ↓
Restart systemd service
```

## Running the Deployment

Make the script executable:

```bash
chmod +x scripts/deploy.sh
```

Run the deployment script from the project root:

```bash
./scripts/deploy.sh
```

## Server Setup

The EC2 instance is prepared with:

* Java installed
* SSH access configured
* A systemd service for running the Spring Boot application
* An Elastic IP address for stable access

## Demo

1. Change the version in the application.
2. Run `./deploy.sh`.
3. Verify the new version:

```bash
curl http://<EC2-IP>:8080/api/version
```

## Purpose

The purpose of this project is to demonstrate practical Linux usage by combining:

* Bash scripting
* File transfer with SCP
* Remote server administration with SSH
* Java application deployment
* Service management with systemd
* Basic CI/CD pipeline logic

## Author

Vitaliy Beletskiy
