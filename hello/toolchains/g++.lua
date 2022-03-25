-- define toolchain
function toolchain_gpp(version)
local suffix = ""
if version then
    suffix = suffix .. "-" .. version
end
toolchain("g++" .. suffix)

    -- set homepage
    set_homepage("https://gcc.gnu.org/")
    set_description("GNU Compiler Collection" .. (version and (" (" .. version .. ")") or ""))

    -- mark as standalone toolchain
    set_kind("standalone")

    -- set toolset
    set_toolset("cc", "gcc" .. suffix)
    set_toolset("cxx", "g++" .. suffix)
    set_toolset("ld", "g++" .. suffix, "gcc" .. suffix)
    set_toolset("sh", "g++" .. suffix, "gcc" .. suffix)
    set_toolset("ar", "ar")
    set_toolset("strip", "strip")
    set_toolset("mm", "gcc" .. suffix)
    set_toolset("mxx", "g++" .. suffix, "gcc" .. suffix)
    set_toolset("as", "gcc" .. suffix)

    on_check(function (toolchain)
        return import("lib.detect.find_tool")("gcc" .. suffix)
    end)

    on_load(function (toolchain)

        -- add march flags
        local march
        if toolchain:is_arch("x86_64", "x64") then
            march = "-m64"
        elseif toolchain:is_arch("i386", "x86") then
            march = "-m32"
        end
        if march then
            toolchain:add("cxflags", march)
            toolchain:add("mxflags", march)
            toolchain:add("asflags", march)
            toolchain:add("ldflags", march)
            toolchain:add("shflags", march)
        end
    end)
end
toolchain_gpp()
