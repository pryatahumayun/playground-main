# CloudFront

CloudFront is AWS's CDN for caching and delivering content close to users.

## Common uses

- cache static websites and frontend assets
- front S3, ALB, API Gateway, or custom origins
- add TLS, edge caching, and global distribution

## Main ideas

- distribution
- origin
- cache behavior
- invalidation

## Good to remember

- CloudFront is a strong default for static sites and global APIs
- cache behavior has a big effect on both performance and correctness
- when debugging, always check whether CloudFront is serving stale content from cache
