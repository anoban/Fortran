module functions
    use iso_fortran_env
    implicit none

contains
    ! let's explore all the signatures available to define functions in Fortran


    function average(array) result(avg) ! the variable parenthesized inside result() specifies the return value
        real(real64) :: avg ! type of the return value can be declared as such, NOTE THE ABSENCE OF INTENT(OUT)
        ! as long as we have the variable name declared inside a result(), intent(whatnot) should not be included in function body
        ! real(real64), intent(out) :: avg is an error

        real(real64), intent(in) :: array(:)    ! we explicitly state that the array argument is an array whose dimensions are not
        ! known at compile time with the (:) signature
        avg = sum(array) / size(array)
    end function average

    integer(int64) function total(x, y)
        integer(int64), intent(in) :: x, y  ! we declare x, y as input valriables, that won't be modofied by the function
        total = x + y   ! return value is implied as the variable with the function's name
        ! return type has already been declared, we shouldn't declare the type of total here!
        ! integer(int64), intent(out) :: total is an error
        ! by using the function's name for a variable, we imply that it's type is function's return type
        ! and it's a intent(out) qualified object
    end function total

    logical function is_equal(x, y) result(eq)
        ! here the return value's type and name has already been defined in the function signature.
        integer(int32), intent(in) :: x, y
        eq = (x == y)
    end function is_equal

end module functions
