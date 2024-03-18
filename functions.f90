module functions
    use iso_fortran_env
    implicit none

contains
    ! In Fortran, functions can return only a single value, it can be a scalar or an array
    ! let's explore all the signatures available to define a function that returns (input + 1) in Fortran

    function definition_0(x) result(r)
        ! as long as we have the return variable name declared inside a result(), intent(out) should not used with it
        ! implicit intent(out) is assumed for the result variable
        integer(int64) :: r ! result(avg) implies intent(out)
        integer(int64), intent(in) :: x
        r = x + 1
    end function definition_0

    integer(int64) function definition_1(x) result(r)
        ! here the return value's type and name has already been defined in the function signature.
        integer(int64), intent(in) :: x
        r = x + 1   ! r has a type real(real64) and is the return value
    end function definition_1

    ! when there is a result() clause enclosing a return variable, a function should not have a dummy variable with
    ! intent(out) or intent(inout) attribute
    ! in the absence of a result() clause, the function name is used as the dummy return variable

    ! signatures without using the result() clause
    integer(int64) function definition_2(x)
        ! definition has an explicit return type in its signature. integer(int64)
        integer(int64), intent(in) :: x
        ! function name is used as a dummy variable for the return value
        definition_2 = x + 1   ! return value is implied as the variable with the function's name
        ! integer(int64), intent(out) :: total is a compile time error
    end function definition_2

    ! function with an explicit intent(out) variable
    function definition_3(x)
        integer(int64), intent(in) :: x ! explict input argument
        integer(int64) :: definition_3  ! declaring the return type as it is missing in the signature
        definition_3 = x + 1
    end function definition_3

    ! functions are allowed to modify their input variables, the functions that do not and do not cause anyside effects can be
    ! declared as pure functions
    function definition_4(x)
        integer(int64), intent(inout) :: x  ! intent(inout) since we intend to modify the value in-place too
        integer(int64) :: definition_4 ! dummy return value
        definition_4 = x + 1    ! return the incremented value too.
        x = x + 1   ! modify the input value in-place
    end function definition_4

    integer(int64) pure function definition_5(x) result(r)
        integer(int64), intent(in) :: x
        ! integer(int64), intent(inout) :: x  is a compile time error
        ! INTENT(OUT) or INTENT(INOUT) specification is not valid for dummies of pure functions.
        r = x + 1

        ! pure functions cannot have side effects, i.e they cannot engage in IO, and cannot cann any non-pure functions
        ! print*, r   is a compile time error
        ! A PURE procedure must not contain a print-stmt, open-stmt, close-stmt, backspace-stmt, endfile-stmt, rewind-stmt,
        ! inquire-stmt.

        ! r = definition_1(x) is a compile time error
        ! Any procedure referenced in a PURE procedure, including one referenced via a defined operation or assignment, must have an
        ! explicit interface and be declared PURE.
    end function definition_5

end module functions

! another type of function is recursive functions
! unlike other languages, Fortran won't compile a recursive function without a recursive qualifier in the function signature
integer(int64) pure recursive function factorial(x) result(r)
    ! for definitions of freestanding functions, implicit none needs to be declared separately
    ! and the necessary modules must be imported separetely
    use iso_fortran_env
    implicit none
    integer(int64), intent(in) :: x
    if (x <= 1) then
        r = 1
    else
        r = x * factorial(x - 1)    ! is a compile time error in a function not declared as recursive
    ! A subroutine or function is calling itself recursively.
    end if
end function factorial

! functions with optional arguments
integer(int64) pure function definition_6(x, inc) result(r)
    use iso_fortran_env
    implicit none
    integer(int64), intent(in) :: x
    integer(int64), intent(in), optional :: inc
    if(present(inc)) then   ! if the optional argument inc is provided at the call site
        r = x + inc ! increment the input by the given value
    else
        r = x + 1   ! else just increment the input by one
    end if
end function definition_6



program main
    use functions
    implicit none
    integer(int64) :: n = 100
    integer(int64), external :: factorial   ! interface to the external freestanding functions
    ! removed the definition_6 return type interface as we provide a dedicated explicit interface below

    interface
        integer(int64) pure function definition_6(x, inc) result(r)
            use iso_fortran_env
            implicit none
            integer(int64), intent(in) :: x
            integer(int64), intent(in), optional :: inc
        end function definition_6
    end interface

    print*, "12 + 1 = ", definition_0(12_int64)
    print*, "12 + 1 = ", definition_1(12_int64)
    print*, "12 + 1 = ", definition_2(12_int64)
    print*, "12 + 1 = ", definition_3(12_int64)

    print*, "12 + 1 = ", definition_4(n)
    print*, "n = ", n

    do n = 0, 20, 1
        print*, "factorial of ", n, " is ", factorial(n)
    end do

    ! okay, as long as we do not pass in an optional argument.
    print*, "definition_6(12) = ", definition_6(12_int64)

    ! when invoking a function that takes optional argument/s, a complete explicit interface is needed
    ! return type interfaces are not enough!
    ! print*, "definition_6(12, 10) = ", definition_6(12_int64, 10_int64) is a compile time error_unit
    ! The procedure has a dummy argument that has the ALLOCATABLE, ASYNCHRONOUS, OPTIONAL, POINTER, TARGET, VALUE or VOLATILE
    ! attribute. Required explicit interface is missing from original source.

    ! interfaces must be grouped with the variable declarations, aren't valid in the executable section.
    print*, "definition_6(12, 10) = ", definition_6(12_int64, 10_int64)
    ! now that we have an explicit interface, this will work just as fine

end program main
