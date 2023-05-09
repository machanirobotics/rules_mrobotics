import os
import shutil
import argparse
import subprocess
from pathlib import Path
from typing import List, Optional


def create_and_copy(src: Path, dest_dir: Path):
    # creating the directory which will contain this file
    dest_dir.mkdir(parents=True, exist_ok=True)

    # copying file to the directory
    shutil.copyfile(str(src), str(dest_dir / src.name), follow_symlinks=True)


def create_and_link(link_src: Path, link_target: Path):
    # create dirs and make symlinks
    link_target.parents[0].mkdir(parents=True, exist_ok=True)
    os.symlink(link_src, link_target)


def main(
    label: str,
    workspace: str,
    input_files: List[Path],
    output_file: Path,
    entrypoint: Optional[Path],
):
    temp_path = Path(os.path.expanduser("~/.cache/rules_genesis/build"))
    if temp_path.exists():
        shutil.rmtree(temp_path)
    
    temp_path.mkdir(parents=True)

    label_as_dir = label.split(":")[0].lstrip("//")
    exec_dir = label.split(":")[1]

    # creating runfiles directory
    runfiles = temp_path / "app.runfiles"

    # creating sdk folder
    sdk = runfiles / workspace

    # creating directories and copying files
    for f in input_files:
        prefix = f.parts[0]

        if prefix == "external":
            # forming dest folder, prefixed with sdk
            dest = sdk / f.parents[0]
            create_and_copy(f, dest)

            # create symlinks
            # get the path to where the symlink will be placed
            link_target = runfiles / f.relative_to("external")

            # get the path to the source file relative from the link target
            link_src = (
                Path(os.path.relpath(str(dest), str(link_target.parents[0]))) / f.name
            )

            create_and_link(link_src, link_target)

        elif prefix == "bazel-out":
            # get the stuff inside bin folder
            f_str = str(f)
            f_str = f_str[f_str.find("bin") :]
            dest = sdk / Path(f_str).relative_to("bin").parents[0]

            create_and_copy(f, dest)

            # if its an external data dir, create the symlinks
            if dest.relative_to(sdk).parts[0] == "external":
                # get the path to where the symlink will be placed
                link_target = runfiles / Path(f_str).relative_to("bin/external")

                # get the path to the source file relative from the link target
                link_src = (
                    Path(os.path.relpath(str(dest), str(link_target.parents[0])))
                    / f.name
                )

                create_and_link(link_src, link_target)

            # checking if the file is an .sh file (the python wrapper) or if its
            # the main python executable. if it is, making it executable
            if f.suffix == ".sh" or (label_as_dir in str(f) and f.name == exec_dir):
                os.chmod(dest / f.name, 0o777)

        else:
            # most likely some project data file, so just dump it in the sdk folder
            dest = sdk / f.parents[0]
            create_and_copy(f, dest)

    # adding entrypoint script to top level directory
    if entrypoint is not None:
        shutil.copyfile(
            str(entrypoint),
            temp_path / entrypoint.name,
            follow_symlinks=True,
        )

    # creating tar file
    subprocess.call(["tar", "-czf", output_file, "-C", str(temp_path), "."])

    # cleaning up
    shutil.rmtree(temp_path)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--label")
    parser.add_argument("--workspace")
    parser.add_argument("--output", type=Path)
    parser.add_argument("--inputs", nargs="+", type=Path)
    parser.add_argument("--entrypoint", type=Path, default=None)

    args = parser.parse_args()
    main(args.label, args.workspace, args.inputs, args.output, args.entrypoint)