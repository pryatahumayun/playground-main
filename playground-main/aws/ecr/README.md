# ECR

Amazon ECR is AWS's managed container registry.

## Common uses

- store Docker images for ECS, EKS, and other container workloads
- push images from local development or CI pipelines
- keep versioned application images close to the runtime environment

## Typical flow

1. create a repository
2. log Docker into the registry
3. build and tag the image
4. push the image
5. let ECS or EKS pull the tagged image

## Good to remember

- ECR login often uses a temporary token from the AWS CLI
- lifecycle policies help clean up old images
- image tags like `latest` are easy to use, but immutable version tags are safer in CI/CD
