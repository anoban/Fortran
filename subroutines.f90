! let's play with subroutines.

module subroutines
    use iso_fortran_env
    implicit none

contains

subroutine quadruple(input, output)
    integer(int64), intent(inout) :: input  ! input argument, if this is to be quadrupled inplace, specify quadruple = true
    integer(int64), optional, intent(out) :: output   ! optional argument to store the result

    ! when only one argument is passed to the subroutine, the input variable will be modified inplace
    ! only when the subroutine is called with two arguments (the second one must be a modifiable lvalue)
    ! the result will be written to the output

    if (present(output)) then
        ! when an optional rgument is passed in,
        ! if inplace = false, the caller must provide a writable output variable
        output = input * input * input * input
    else
        input = input * input * input * input
    end if

end subroutine quadruple

end module subroutines

subroutine increment(x)
    use iso_fortran_env
    implicit none
    integer(int64), intent(inout) :: x
    x = x + 1
end subroutine increment

program main
    use iso_fortran_env
    use subroutines
    implicit none

    integer(int64) :: result = 0, i = 0
    external increment  ! implicit interface to the freestanding subroutine increment
    ! since subroutines do not return anything, we do not need to specify the return type in the implicit interface

    do i = 1, 100, 1
        ! if i is a even number call the subroutine with the optional arg
        if (mod(i, 2_int64) == 0) then
            call quadruple(i, result)
            print*, "i = ", i, "result = ", result
        else
            ! ask for an inplace modification, this will shorten the number of loop iterations, as the loop counter will be
            ! quadrupled in-place
            call quadruple(i)
            print*, "i = ", i, "result = ", result
        end if
    end do

    call increment(result)

end program main
