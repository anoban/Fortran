program main
    use iso_fortran_env
    implicit none

type ram
    integer(int64) :: yom
    integer(int32) :: warranty_months
    real(real64) :: price
    logical :: is_covered_by_warranty
    logical :: is_on_sale
    character(len=100) :: model
    character(len=100) :: make
end type

type pair
    real(real64) :: first, second
end type pair

    type(pair), allocatable :: tuples(:)
    ! without explictly initializing these variables, we'll run into floating point exceptions in line 35 & 36
    real(real128) :: t_first = 0.00, t_second = 0.00, l_first = 0.00, l_second = 0.00
    integer(int64) :: i
    integer(int64), parameter :: nelems = 100000

    allocate(tuples(nelems))
    do i = 1, nelems
        call random_number(tuples(i)%first)
        call random_number(tuples(i)%second)
    end do

    t_first = sum(tuples%first)
    t_second = sum(tuples%second)

    do i = 1, nelems
        l_first = l_first + tuples(i)%first
        l_second = l_second + tuples(i)%second
    end do

    deallocate(tuples)

    print*, "array sums :: firsts = ", t_first, " seconds = ", t_second
    print*, "loop sums :: firsts = ", l_first, " seconds = ", l_second

end program main
