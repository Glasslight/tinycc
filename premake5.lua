dst = "_build"
gen = "gen"

workspace "tinycc"

    configurations { "Debug", "Release" }
    platforms { "Win64" }
    architecture "x64"

    startproject "libtcc"

    location(dst)

    filter "action:vs2019"
        characterset "MBCS"

    filter {}

    include "tinycc"
