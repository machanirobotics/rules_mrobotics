# buildifier: disable=module-docstring
load("//repo/private:s3.bzl", _s3_archive = "s3_archive", _s3_file = "s3_file")
load("//repo/private:patched_local_repository.bzl", _patched_local_repository = "patched_local_repository")

s3_file = _s3_file
s3_archive = _s3_archive

patched_local_repository = _patched_local_repository
