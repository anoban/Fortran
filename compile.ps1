$cfiles = [System.Collections.ArrayList]::new()
$unrecognized = [System.Collections.ArrayList]::new()


foreach ($arg in $args) {
    if ($arg -clike "*.f90") {
        [void]$cfiles.Add($arg.ToString().Replace(".\", ""))
    }
    else {
        [void]$unrecognized.Add($arg)
    }
}

if ($unrecognized.Count -ne 0) {
    Write-Error "Incompatible files passed for compilation: ${unrecognized}"
    Exit 1
}

$cflags = @(
    "/align:all", # adds padding bytes whenever possible to data items in common blocks and structures
    "/auto", # makes all local, non-saved variables to be allocated on stack
    "/debug:none",
    "/extend-source:132",
    "/F0x3200000", # stack size in bytes (50 MiB)
    "/fp:strict", # enables precise and except, disables contractions, and enables the property that allows modification of the floating-point
    # environment.
    "/fpe:0", # floating-point invalid, divide-by-zero, and overflow exceptions are enabled throughout the application.
    "/fpe-all:0",
    "/free",
    "/GF",  # enables read-only string pooling optimizations.
    "/guard:cf",    # enables the control flow protection mechanism.
    "/heap-arrays:5120",# put automatic arrays and arrays bigger than 5 MiBs created for temporary computations on the heap instead of the stack.
    # the value is in KiBs.
    "/MP",
    "/names:lowercase", # changing this can cause unresolved symbol errors at link time.
    "/noaltparam", # alternate syntax for PARAMETER statements is disallowed. i.e PARAMETER c = expr [, c = expr] ...
    <#
    This statement assigns a name to a constant (as does the standard PARAMETER statement), but there are no parentheses surrounding the
    assignment list. In this alternative statement, the form of the constant, rather than implicit or explicit typing of the name,
    determines the data type of the variable.
    #>
    "/nodebug-parameters", # no debug information for any PARAMETERs used in the program
    "/nofixed",
    "/nofltconsistency", # provides better accuracy and runtime performance at the expense of less consistent floating-point results.
    "/nofpp",
    "/norecursive",
    "/noreentrancy", # tells the runtime library (RTL) that the program does not rely on threaded or asynchronous reentrancy. The RTL will not guard against
    # such interrupts inside its own critical regions.
    "/standard-realloc-lhs",
    <# This option determines whether the compiler uses the current Fortran Standard rules or the old Fortran 2003 rules when interpreting
    assignment statements. Option standard-realloc-lhs (the default), tells the compiler that when the left-hand side of an assignment is an
    allocatable object, it should be reallocated to the shape of the right-hand side of the assignment before the assignment occurs. This is
    the current Fortran Standard definition. This feature may cause extra overhead at runtime. This option has the same effect as option assume
    realloc_lhs. If you specify nostandard-realloc-lhs, the compiler uses the old Fortran 2003 rules when interpreting assignment statements.
    The left-hand side is assumed to be allocated with the correct shape to hold the right-hand side. If it is not, incorrect behavior will occur.
    This option has the same effect as option assume norealloc_lhs. #>
    "/O3",  # maximum optimizations.
    "/Oa",  # procedure calls do not alias local variables.
    "/Ob2", # enables inlining of any function at the compiler's discretion.
    "/Oi",
    "/Ot",  # prioritize (optimize for) execution speed (at the expense of) over executable size.
    "/Qansi-alias", # compiler assumes certain rules of the Fortran standard regarding aliasing and array bounds.
    "/Qauto-scalar", # scalar variables of intrinsic types INTEGER, REAL, COMPLEX, and LOGICAL are allocated to the runtime stack.
    "/Qbranches-within-32B-boundaries", # compiler aligns branches and fused branches on 32-byte boundaries for better performance.
    "/Qcf-protection:full", # enables shadow stack protection and endbranch (EB) generation.
    # "/Qcoarray:shared",
    # "/Qcoarray-num-images:8",
    "/Qfma",
    "/Qfp-speculation:strict", # disable speculation as they may cause a floating-point exception.
    "/Qftz-", # do not flush undeflow results to zero.
    "/Qimf-domain-exclusion:0", # input arguments domains on which math functions must provide correct results. - all of them
    # (extremes, nans, infinities, denormals, zeros & none)
    "/Qimf-precision:high", # equivalent to max-error = 1.0.
    "/Qipo", # alias for -flto=full, enables full link time optimizations.
    "/Qm64", # compiler generates code for Intel® 64 architecture
    "/Qopt-dynamic-align",
    "/Qopt-for-throughput:single-job",
    "/Qopt-matmul-", # needs openMP, fuck that
    "/Qopt-mem-layout-trans:4", # aggressive memory layout transformations.
    "/Qopt-multiple-gather-scatter-by-shuffles",
    "/Qopt-prefetch:5", # prefetching is to reduce cache misses by providing hints to the processor about when data should be loaded into the cache.
    "/Qopt-streaming-stores:auto",
    "/Qopt-zmm-usage:high",
    "/Qpad",
    "/Qpc80", # rounds the significand to 64 bits (extended precision)
    "/Qprotect-parens-", # don't honors parentheses when floating-point expressions are evaluated.
    "/Qsafe-cray-ptr", # Cray* pointers do not alias other variables.
    "/Qtrapuv", # nitializes stack local variables to an unusual value to aid error detection.
    "/Qunroll:1000",
    "/Qvecabi:cmdtarget",
    "/Qvec-peel-loops",
    "/Qvec-remainder-loops",
    "/Qvec-threshold:100", # vectorize loops only when 100% sure of a potential performance boost
    "/Qvec-with-mask",
    "/QxTIGERLAKE",   # processor features the compiler may target, including which instruction sets and optimizations it may generate
    "/stand:f18",
    "/tune:tigerlake", # i5-1135G7
    "/warn:all",
    "/wrap-margin-", # by default, Fortran introduces line breaks ("wrapping the right margin of records" in Fortran parlance) when the characters are past 80 columns
    # /wrap-margin- disables it
    "/link /DEBUG:NONE /guard:cf"
)

Write-Host "ifx.exe ${cfiles} ${cflags}" -ForegroundColor Cyan
ifx.exe $cfiles $cflags

# If ifx.exe returned 0, (i.e if the compilation succeeded,)
if ($? -eq $True){
    foreach($file in $cfiles){
        Remove-Item $file.Replace(".f90", ".obj") -Force
    }
}
