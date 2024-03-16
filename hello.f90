program hello
    ! revisiting Fortran
    use iso_fortran_env
    implicit none
    character(len = 100) :: greeting = "Hi there! Anoban!"
    real(real64), allocatable :: randoms(:)
    real(real64) :: mean

    print*, greeting
    allocate(randoms(100000))
    call random_number(randoms)

    mean = sum(randoms) / size(randoms)
    print*, "mean is ", mean
    deallocate(randoms)

end program hello