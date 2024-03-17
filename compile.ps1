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
    "/F0x3200000", # stack size in bytes (50 MiB)
    "/fp:strict", # floating point model.
    "/GF",  # enables read-only string pooling optimizations.
    "/guard:cf",    # enables the control flow protection mechanism.
    "/heap-arrays:5120",# put automatic arrays and arrays bigger than 5 MiBs created for temporary computations on the heap instead of the stack.
    # the value is in KiBs.
    "/MP",
    "/noreentrancy", # tells the runtime library (RTL) that the program does not rely on threaded or asynchronous reentrancy. The RTL will not guard against
    # such interrupts inside its own critical regions.
    "/O3",  # maximum optimizations.
    "/Oa",  # procedure calls do not alias local variables.
    "/Oi",
    "/Ot",  # prioritize (optimize for) execution speed (at the expense of) over executable size.
    "/Qansi-alias", # compiler assumes certain rules of the Fortran standard regarding aliasing and array bounds.
    "/Qbranches-within-32B-boundaries", # compiler aligns branches and fused branches on 32-byte boundaries for better performance.
    "/Qcf-protection:full", # enables shadow stack protection and endbranch (EB) generation.
    # "/Qcoarray:shared",
    # "/Qcoarray-num-images:8",
    "/Qipo", # alias for -flto=full, enables full link time optimizations.
    "/Qm64", # compiler generates code for Intel® 64 architecture
    "/Qopt-dynamic-align",
    "/Qopt-for-throughput:single-job",
    "/Qopt-matmul", # needs openMP
    "/Qopt-mem-layout-trans:4", # aggressive memory layout transformations.
    "/Qopt-multiple-gather-scatter-by-shuffles",
    "/Qopt-prefetch:5", # prefetching is to reduce cache misses by providing hints to the processor about when data should be loaded into the cache.
    "/Qopt-streaming-stores:auto",
    "/Qopt-zmm-usage:high",
    "/Qpad",
    "/Qprotect-parens-", # don't honors parentheses when floating-point expressions are evaluated.
    "/Qsafe-cray-ptr", # Cray* pointers do not alias other variables.
    "/Qunroll:1000",
    "/Qvecabi:gcc",
    "/Qvec-peel-loops",
    "/Qvec-remainder-loops",
    "/Qvec-threshold:100", # vectorize loops only when 100% sure of a potential performance boost
    "/Qvec-with-mask",
    "/QxTIGERLAKE",   # processor features the compiler may target, including which instruction sets and optimizations it may generate
    "/tune:tigerlake", # i5-1135G7
    "/warn:all",
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
