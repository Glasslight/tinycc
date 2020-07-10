    path_cwd = os.getcwd();

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

    tcc_a_files = {

        "lib/libtcc1.c",
        "lib/alloca86_64.S",
        "lib/alloca86_64-bt.S",
        "win32/lib/crt1.c",
        "win32/lib/crt1w.c",
        "win32/lib/wincrt1.c",
        "win32/lib/wincrt1w.c",
        "win32/lib/dllcrt1.c",
        "win32/lib/dllmain.c",
        "win32/lib/chkstk.S"
    }

    project "tcc"

        kind "ConsoleApp"

        language "C"

        files { tcc_files }
        defines { tcc_defines }

    project "libtcc"

        kind "SharedLib"

        language "C"

        files { tcc_files }

        defines {
            tcc_defines,
            "LIBTCC_AS_DLL"
        }

    project "libtcc1_64_a"

        kind "Utility"

        dependson {
            "tcc",
            "libtcc"
        }

        files { tcc_a_files }

        tcc_exe = "%{cfg.buildtarget.directory}/tcc.exe"

        prebuildcommands {
            "{COPY} " .. path_cwd .. "/include %{cfg.buildtarget.directory}/include",
            "{COPY} " .. path_cwd .. "/win32/include %{cfg.buildtarget.directory}/include",
            "{MKDIR} %{cfg.buildtarget.directory}/obj",
            "{MKDIR} %{cfg.buildtarget.directory}/lib"
        }

        filter { "files:**.*" }
            buildmessage "Compiling with tcc: %{file.relpath}"
            buildcommands {
                "%{cfg.buildtarget.directory}/tcc.exe -m64 -c %{file.relpath} -o %{cfg.buildtarget.directory}/obj/%{file.basename}.o",
            }

            buildoutputs {
                "%{cfg.buildtarget.directory}/obj/%{file.basename}.o"
            }

        filter {}

        objs = {}

        for _, file in ipairs(tcc_a_files) do
            local obj_file = "%{cfg.buildtarget.directory}/obj/" .. path.getbasename(file) .. ".o"
            table.insert(objs, obj_file)
        end

        postbuildcommands {
            "%{cfg.buildtarget.directory}/tcc.exe -m64 -ar %{cfg.buildtarget.directory}/lib/libtcc1-64.a " .. table.concat(objs, " ")
        }

        buildoutputs {
            "%{cfg.buildtarget.directory}/lib/libtcc1-64.a"
        }
