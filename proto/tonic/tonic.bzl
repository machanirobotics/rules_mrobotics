# buildifier: disable=module-docstring
load("@rules_proto_grpc//:defs.bzl", "ProtoCompileInfo", "ProtoPluginInfo", "proto_compile_attrs", "proto_compile_impl")
load("@rules_rust//rust:defs.bzl", "rust_common")
load("@rules_rust//rust/private:rustc.bzl", "rustc_compile_action")
load("@rules_rust//rust/private:utils.bzl", "can_build_metadata", "compute_crate_name", "determine_output_hash", "transform_deps")

tonic_grpc_compile = rule(
    implementation = proto_compile_impl,
    attrs = dict(
        proto_compile_attrs,
        _plugins = attr.label_list(
            providers = [ProtoPluginInfo],
            default = [
                Label("//bazel/lib/proto:rust_prost_plugin"),
                Label("//bazel/lib/proto:rust_tonic_plugin"),
                Label("//bazel/lib/proto:rust_crate_plugin"),
            ],
            doc = "List of protoc plugins to apply",
        ),
    ),
    toolchains = [str(Label("@rules_proto_grpc//protobuf:toolchain_type"))],
)

def _tonic_rust_library_impl(ctx):
    # fixing up the files
    compilation = ctx.attr.compilation[ProtoCompileInfo]
    in_dir = compilation.output_dirs.to_list()[0]
    fixed_dir_name = "%s_fixed" % compilation.label.name
    fixed_dir = ctx.actions.declare_directory(fixed_dir_name)
    ctx.actions.run(
        outputs = [fixed_dir],
        inputs = [in_dir],
        executable = ctx.executable._fixer,
        arguments = [in_dir.path, fixed_dir.path],
    )

    # creating lib.rs
    lib_rs = ctx.actions.declare_file("%s_lib.rs" % fixed_dir_name)
    ctx.actions.write(
        lib_rs,
        'include!("%s/mod.rs");' % fixed_dir_name,
        False,
    )

    # compiling the rust crate
    srcs = depset([lib_rs, fixed_dir])
    proto_toolchain = ctx.toolchains[Label("@rules_rust//proto:toolchain_type")]
    rs_toolchain = ctx.toolchains[Label("@rules_rust//rust:toolchain_type")]
    crate_name = compute_crate_name(ctx.workspace_name, ctx.label, rs_toolchain)

    output_hash = determine_output_hash(lib_rs, ctx.label)
    output_dir = "%s.grpc.rust" % crate_name
    rust_lib = ctx.actions.declare_file("%s/lib%s-%s.rlib" % (
        output_dir,
        crate_name,
        output_hash,
    ))
    rust_metadata = None
    if can_build_metadata(rs_toolchain, ctx, "rlib"):
        rust_metadata = ctx.actions.declare_file("%s/lib%s-%s.rmeta" % (
            output_dir,
            crate_name,
            output_hash,
        ))

    compile_action_deps = depset(transform_deps(proto_toolchain.grpc_compile_deps))
    return rustc_compile_action(
        ctx = ctx,
        attr = ctx.attr,
        toolchain = rs_toolchain,
        crate_info = rust_common.create_crate_info(
            name = crate_name,
            type = "rlib",
            root = lib_rs,
            srcs = srcs,
            deps = compile_action_deps,
            proc_macro_deps = depset([]),
            aliases = {},
            output = rust_lib,
            metadata = rust_metadata,
            edition = proto_toolchain.edition,
            rustc_env = {},
            is_test = False,
            compile_data = depset([target.files for target in getattr(ctx.attr, "compile_data", [])]),
            compile_data_targets = depset(getattr(ctx.attr, "compile_data", [])),
            wrapped_crate_type = None,
            owner = ctx.label,
        ),
        output_hash = output_hash,
    )

tonic_rust_library = rule(
    implementation = _tonic_rust_library_impl,
    attrs = {
        "compilation": attr.label(mandatory = True),
        "_process_wrapper": attr.label(
            default = Label("@rules_rust//util/process_wrapper"),
            executable = True,
            allow_single_file = True,
            cfg = "exec",
        ),
        "_fixer": attr.label(
            executable = True,
            cfg = "exec",
            default = Label("//bazel/lib/proto:rust_fixer"),
        ),
    },
    fragments = ["cpp"],
    host_fragments = ["cpp"],
    toolchains = [
        str(Label("@rules_rust//rust:toolchain_type")),
        str(Label("@rules_rust//proto:toolchain_type")),
        str(Label("@bazel_tools//tools/cpp:toolchain_type")),
    ],
)

# buildifier: disable=function-docstring
def tonic_grpc_library(name, protos, visibility = []):
    name_pb = name + "_pb"

    tonic_grpc_compile(
        name = name_pb,
        protos = protos,
    )

    tonic_rust_library(
        name = name,
        compilation = name_pb,
        visibility = visibility,
    )
