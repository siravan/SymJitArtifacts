#!/usr/bin/env julia

using Tar, Inflate, SHA

function single_artifact(io, arch, os, name)
    a = Tar.tree_hash(IOBuffer(inflate_gzip(name)))
    b = bytes2hex(open(sha256, name))

    println(io, "[[symjit]]")
    println(io, "arch = \"$arch\"")
    println(io, "git-tree-sha1 = \"$a\"")
    println(io, "os = \"$os\"")

    println(io, "\t[[symjit.download]]")
    println(io, "\tsha256 = \"$b\"")
    println(io, "\turl = \"https://github.com/siravan/SymJitArtifacts/raw/main/$name\"")
    println(io)
end


function generate()
    io = open("Artifacts.toml", "w")

    single_artifact(io, "x86_64", "linux", "symjit_linux-64.tar.gz")
    single_artifact(io, "x86_64", "windows", "symjit_win-64.tar.gz")
    single_artifact(io, "x86_64", "macos", "symjit_osx-64.tar.gz")
    single_artifact(io, "aarch64", "macos", "symjit_osx-arm64.tar.gz")

    close(io)
end

generate()
