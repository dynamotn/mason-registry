return {
  name = 'checkov',
  description = 'Policy checks of Terraform, Kubernetes, Dockerfile and other infrastructure code',
  homepage = 'https://github.com/bridgecrewio/checkov',
  licenses = {
    'Apache-2.0',
  },
  languages = {
    'Terraform',
    'Dockerfile',
    'YAML',
  },
  categories = {
    'Linter',
  },
  source = {
    id = 'pkg:pypi/checkov@3.4.0',
    supported_platforms = { 'unix' },
  },
  bin = {
    checkov = 'pypi:checkov',
  },
}
