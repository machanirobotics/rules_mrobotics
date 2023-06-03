# buildifier: disable=module-docstring
load("@rules_proto_grpc//:defs.bzl", "ProtoCompileInfo", "ProtoPluginInfo", "proto_compile_attrs", "proto_compile_impl")
load("@rules_rust//rust:defs.bzl", "rust_library")

tonic_grpc_compile = rule(
    implementation = proto_compile_impl,
    attrs = dict(
        proto_compile_attrs,
        _plugins = attr.label_list(
            providers = [ProtoPluginInfo],
            default = [
                Label("//rust/proto/private:rust_prost_plugin"),
                Label("//rust/proto/private:rust_tonic_plugin"),
                Label("//rust/proto/private:rust_crate_plugin"),
            ],
            doc = "List of protoc plugins to apply",
        ),
    ),
    toolchains = [str(Label("@rules_proto_grpc//protobuf:toolchain_type"))],
)

def _tonic_grpc_fixer_impl(ctx):
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

    return DefaultInfo(
        files = depset([fixed_dir, lib_rs]),
    )

tonic_grpc_fixer = rule(
    implementation = _tonic_grpc_fixer_impl,
    attrs = {
        "compilation": attr.label(mandatory = True),
        "_fixer": attr.label(
            executable = True,
            cfg = "exec",
            default = Label("//rust/proto/private:rust_fixer"),
        ),
    },
)

# buildifier: disable=function-docstring
def tonic_grpc_library(name, protos, tonic, prost, visibility = []):
    name_pb = name + "_pb"
    name_fixed = name + "_fixed"

    tonic_grpc_compile(
        name = name_pb,
        protos = protos,
    )

    tonic_grpc_fixer(
        name = name_fixed,
        compilation = name_pb,
    )

    rust_library(
        name = name,
        srcs = [
            name_fixed,
        ],
        deps = [
            tonic,
            prost,
        ],
        visibility = visibility,
    )
