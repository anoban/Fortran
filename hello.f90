recursive function factorial(n) result(answer)
    use iso_fortran_env
    implicit none
    integer(int64), intent(in) :: n
    integer(int64) :: answer
    if(n < 0) then
        answer = 0
    else if (n == 0) then
        answer = 1
    else
        answer = n * factorial(n - 1)
    end if
end function factorial

real(real128) pure function meanval(array) result(m)
    use iso_fortran_env
    implicit none
    real(real64), intent(in) :: array(:)
    m = sum(array) / size(array)
end function meanval

pure subroutine gcd(x,  y, result)
    use iso_fortran_env
    implicit none

    integer(int64), intent(in) :: x
    integer(int64), intent(in) :: y
    integer(int64), intent(inout) :: result

    integer(int64) :: small, i
    if (x > y) then
        small = x
    else
        small = y
    end if

    do i = small, 1, -1
        if((modulo(x, i) == 0) .and. modulo(y, i) == 0) then
            result = i
            exit
        end if
    end do

end subroutine gcd

program hello
    ! revisiting Fortran
    use iso_fortran_env
    use mean
    implicit none
    character(len = 100) :: greeting = "Hi there! Anoban!"
    real(real64), allocatable :: randoms(:)
    real(real64) :: mean_

    integer(int64), external :: factorial
    external gcd    ! subroutines do not need return type declaration (because there's no "return")
    real(real128), external :: meanval
    integer(int64) :: i, j = 100000, gcd_result

    print*, "uninitialized real64 value = ", mean_

    print*, greeting
    allocate(randoms(100000))
    call random_number(randoms)

    mean_ = sum(randoms) / size(randoms)
    print*, "mean is ", mean_
    print*, "mean is ", average(randoms)
    print*, "mean is ", meanval(randoms)
    deallocate(randoms)

    ! cause a divide by zero error
    ! mean_ = mean_ / 0.000   ! works :)

    do i = 20, 0, -1
        print*, "factorial of ", i , " is ", factorial(i)
    end do

    do i = 200, 1, -10
        call gcd(i, j, gcd_result)
        print*, "gcd of ", i , ", ", j,  " is ", gcd_result
        j = j - 100
    end do

end program hello
