# 🚀 AWS Native CI/CD with CodePipeline + CodeBuild + S3

This repository implements a **simple AWS-native CI/CD pipeline** using:
- **AWS CodePipeline** – to trigger the pipeline on GitHub commits
- **AWS CodeBuild** – to build a Docker image from the source code
- **Amazon S3** – to store the built Docker image archive (`.tar`)

---

## 🔧 Pipeline Workflow

1. Developer pushes code to **GitHub**
2. **AWS CodePipeline** detects the change
3. **CodeBuild**:
   - Authenticates to Docker Hub
   - Builds a Docker image from the `Dockerfile`
   - Saves the image as a `.tar` archive
   - Uploads the archive to an **S3 bucket**

---

## 📁 Repository Structure
.
├── Dockerfile
├── buildspec.yml # Instructions for CodeBuild
└── README.md 

---

## 📝 Prerequisites

Before setting up the pipeline:

- ✅ An **AWS account**
- ✅ A **GitHub repo** with a `Dockerfile`
- ✅ A **Docker Hub account**
- ✅ An **S3 bucket** (e.g., `your-s3-bucket-name`)
- ✅ **CodeBuild** and **CodePipeline** service roles with appropriate permissions

---

## 🧱 Environment Variables to Set in CodeBuild

In the CodeBuild project, set these environment variables:

| Name                | Type      | Example Value             |
|---------------------|-----------|---------------------------|
| `DOCKERHUB_USERNAME`| Plaintext | your-dockerhub-username   |
| `DOCKERHUB_PASSWORD`| Secure    | your-dockerhub-password   |
| `S3_BUCKET`         | Plaintext | your-s3-bucket-name       |
| `IMAGE_NAME`        | Plaintext | portfolio-website         |
| `ARCHIVE_NAME`      | Plaintext | portfolio-website.tar     |

✅ Check **“Secure”** for `DOCKERHUB_PASSWORD`.

---

## 📦 buildspec.yml

This file tells CodeBuild what to do:

```yaml
version: 0.2

env:
  variables:
    S3_BUCKET: "your-s3-bucket-name"
    IMAGE_NAME: "portfolio-website"
    ARCHIVE_NAME: "portfolio-website.tar"

phases:
  pre_build:
    commands:
      - echo Logging in to Docker Hub...
      - echo "$DOCKERHUB_PASSWORD" | docker login -u "$DOCKERHUB_USERNAME" --password-stdin

  build:
    commands:
      - echo Build started on `date`
      - docker build -t $IMAGE_NAME .

  post_build:
    commands:
      - echo Saving Docker image to archive...
      - docker save $IMAGE_NAME > $ARCHIVE_NAME
      - echo Uploading image to S3...
      - aws s3 cp $ARCHIVE_NAME s3://$S3_BUCKET/docker-images/$ARCHIVE_NAME
