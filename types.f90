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



end program main
