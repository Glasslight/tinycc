workspace "tinyc"

    configurations { "Debug", "Release" }
    platforms { "Win64" }
    architecture "x64"

    startproject "tinyc"

    location("_build/")

    filter "action:vs2019"
        characterset "MBCS"

    filter {}

    tcc_files = {

        "i386-asm.h",
        "i386-asm.c",
        "i386-gen.h",
        "i386-tok.h",
        "tcc.h",
        "tcc.c",
        "libtcc.h",
        "libtcc.c",
        "tccasm.c",
        "tccelf.c",
        "tccgen.c",
        "tccpe.c",
        "tccpp.c",
        "tccrun.c",
        "tcctok.h",
--      "tcctools.c",
        "x86_64-asm.h",
        "x86_64-gen.c",
        "x86_64-link.c"
    }

    tcc_defines = {

        "_CRT_SECURE_NO_WARNINGS",
        "_CRT_NONSTDC_NO_WARNINGS",
        "TCC_TARGET_PE",
        "TCC_TARGET_X86_64",
        "TCC_LIBTCC1=\"libtcc1-64.a\"",
        "TCC_VERSION=\"0.9.27\"",
        "ONE_SOURCE=0"
    }

    project "tinyc"

        kind "ConsoleApp"

        language "C"

        files {
            tcc_files
        }

        defines {
            tcc_defines
        }

    project "libtcc"

        kind "SharedLib"

        language "C"

        files {
            tcc_files
        }

        defines {
            tcc_defines,
            "LIBTCC_AS_DLL"
        }

        filter {}
