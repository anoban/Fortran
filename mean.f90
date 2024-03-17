module mean
    use iso_fortran_env
    implicit none

contains

    pure function average(array) result(avg)
        real(real64) :: avg
        real(real64), intent(in) :: array(:)
        avg = sum(array) / size(array)
    end function average

end module mean
