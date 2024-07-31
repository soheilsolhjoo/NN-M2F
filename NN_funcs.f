	  module NN_funcs
	  implicit none
	  contains
	  
	  function mapminmax_apply(x, xoffset, gain, ymin, i) result(y)
	  !implicit none
	  INTEGER i
	  real*8, intent(in) :: x(i,1), xoffset(i,1), gain(i,1), ymin(i,1)
	  real*8 :: y(i,1)
      y(1:i,1) = x(1:i,1) - xoffset(1:i,1)
	  y(1:i,1) = y(1:i,1) * gain(1:i,1)
!	  y = dot_product(y,gain)
	  y(1:i,1) = y(1:i,1) + ymin(1,1)
	  end function mapminmax_apply

	  function tansig_apply(n,i,j) result(y)
	  !implicit none
	  INTEGER i,j
	  real*8 n(i,j)
	  real*8 y(i,j)
	  y = 2. / (1. + exp(-2.*n)) - 1.
	  end function tansig_apply
	  
	  function mapminmax_reverse(y, xoffset, gain, ymin, j) result(x)
	  !implicit none
	  integer j
	  real*8, intent(in) :: y(j), xoffset, gain, ymin
	  real*8 x(j)
	  x = y-ymin
	  x = x/gain
	  x = x+xoffset
	  end function mapminmax_reverse

	  end module NN_funcs