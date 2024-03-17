program hello
    ! revisiting Fortran
    use iso_fortran_env
    use mean
    implicit none
    character(len = 100) :: greeting = "Hi there! Anoban!"
    real(real64), allocatable :: randoms(:)
    real(real64) :: mean_

    print*, "uninitialized real64 value = ", mean_

    print*, greeting
    allocate(randoms(100000))
    call random_number(randoms)

    mean_ = sum(randoms) / size(randoms)
    print*, "mean is ", mean_
    print*, "mean is ", average(randoms)
    deallocate(randoms)

    ! cause a divide by zero error
    mean_ = mean_ / 0.000   ! works :)

end program hello
