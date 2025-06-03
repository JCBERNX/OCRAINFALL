program Hot97Oakland
  implicit none

  ! ------------------------------------------------------------
  ! Parameters: Define the span from 1979 through 2011
  ! ------------------------------------------------------------
  integer, parameter :: start_year = 1979
  integer, parameter :: end_year   = 2011
  integer, parameter :: num_years  = end_year - start_year + 1  ! 33 years
  integer, parameter :: num_months = 12
  integer, parameter :: total_vals = num_years * num_months     ! 396 values

  ! ------------------------------------------------------------
  ! Variable declarations
  ! ------------------------------------------------------------
  integer :: i, j, year, month, ios, idx
  integer :: maxcount, mode_index
  integer :: rec_unit = 10         ! Unit number for reading CSV
  real    :: value                 ! Temporary storage for CSV reading
  real, allocatable :: precip(:,:) ! precip(year_index, month)
  real, allocatable :: flat_data(:)    ! Flattened array of 396 values
  real, allocatable :: sorted_data(:)  ! For sorting before median
  real :: mean_val, median_val, mode_val, std_dev, ci_low, ci_high
  real :: z_score = 1.96               ! Z-value for 95% CI
  real :: sum, sumsq
  integer :: counts(1000)              ! Bins for mode (two-decimal)
  real :: month_totals(num_months), month_averages(num_months)
  real :: year_totals(num_years), year_averages(num_years)
  logical, parameter :: debug_mode = .true.
  character(len=9), dimension(num_months) :: month_names = &
       ['January  ', 'February ', 'March    ', 'April    ', 'May      ', 'June     ', &
        'July     ', 'August   ', 'September', 'October  ', 'November ', 'December ']

  ! ------------------------------------------------------------
  ! Allocate all necessary arrays
  ! ------------------------------------------------------------
  allocate(precip(num_years, num_months))
  allocate(flat_data(total_vals))
  allocate(sorted_data(total_vals))

  ! ------------------------------------------------------------
  ! Initialize arrays to zero
  ! ------------------------------------------------------------
  precip = 0.0
  flat_data = 0.0
  sorted_data = 0.0
  month_totals = 0.0
  month_averages = 0.0
  year_totals = 0.0
  year_averages = 0.0
  counts = 0

  ! ------------------------------------------------------------
  ! Open the CSV file and read all 396 lines
  ! ------------------------------------------------------------
  open(unit = rec_unit, file = 'OAKLAND_MONTHLY.csv', status = 'old', action = 'read', iostat = ios)
  if (ios /= 0) then
     print *, 'Error: Unable to open OAKLAND_MONTHLY.csv'
     stop
  end if

  ! Discard the header line (“Year,Month,Precip_mm”)
  read(rec_unit, '(A)', iostat = ios)
  if (ios /= 0) then
     print *, 'Error: Failed to read header from CSV'
     stop
  end if

  ! Read each record: Year, Month, Precip_mm
  idx = 0
  do
    read(rec_unit, *, iostat = ios) year, month, value
    if (ios /= 0) exit         ! End of file reached or error
    if (year < start_year .or. year > end_year) cycle
    if (month < 1       .or. month > num_months) cycle

    idx = idx + 1
    precip(year - start_year + 1, month) = value
    if (idx >= total_vals) exit
  end do

  close(rec_unit)

  if (idx < total_vals) then
    print *, 'Warning: Only ', idx, ' of ', total_vals, ' values read. Filling rest with 0.0'
    do i = idx + 1, total_vals
      flat_data(i) = 0.0
    end do
  end if

  ! ------------------------------------------------------------
  ! Flatten precip array into flat_data(1:396)
  ! ------------------------------------------------------------
  idx = 0
  do i = 1, num_years
    do j = 1, num_months
      idx = idx + 1
      flat_data(idx) = precip(i, j)
    end do
  end do

  ! ------------------------------------------------------------
  ! Compute Mean
  ! ------------------------------------------------------------
  sum = 0.0
  do i = 1, total_vals
    sum = sum + flat_data(i)
  end do
  mean_val = sum / real(total_vals)

  ! ------------------------------------------------------------
  ! Compute Standard Deviation (sample SD)
  ! ------------------------------------------------------------
  sumsq = 0.0
  do i = 1, total_vals
    sumsq = sumsq + (flat_data(i) - mean_val)**2
  end do
  std_dev = sqrt(sumsq / real(total_vals - 1))

  ! ------------------------------------------------------------
  ! Compute 95% Confidence Interval for the Mean
  ! ------------------------------------------------------------
  ci_low  = mean_val - z_score * std_dev / sqrt(real(total_vals))
  ci_high = mean_val + z_score * std_dev / sqrt(real(total_vals))

  ! ------------------------------------------------------------
  ! Compute Median by sorting sorted_data(1:396)
  ! ------------------------------------------------------------
  sorted_data = flat_data
  call sort_array(sorted_data)
  if (mod(total_vals, 2) == 0) then
    median_val = 0.5 * (sorted_data(total_vals/2) + sorted_data(total_vals/2 + 1))
  else
    median_val = sorted_data((total_vals + 1)/2)
  end if

  ! ------------------------------------------------------------
  ! Compute Mode by binning to two decimals
  ! ------------------------------------------------------------
  counts = 0
  do i = 1, total_vals
    idx = int(flat_data(i) * 100.0 + 0.5)   ! round to nearest hundredth
    if (idx >= 1 .and. idx <= 1000) then
      counts(idx) = counts(idx) + 1
    end if
  end do
  maxcount = 0
  mode_index = 0
  do i = 1, 1000
    if (counts(i) > maxcount) then
      maxcount = counts(i)
      mode_index = i
    end if
  end do
  mode_val = real(mode_index) / 100.0

  ! ------------------------------------------------------------
  ! Compute Monthly Totals & Averages
  ! ------------------------------------------------------------
  do j = 1, num_months
    month_totals(j) = 0.0
    do i = 1, num_years
      month_totals(j) = month_totals(j) + precip(i, j)
    end do
    month_averages(j) = month_totals(j) / real(num_years)
  end do

  ! ------------------------------------------------------------
  ! Compute Yearly Totals & Averages
  ! ------------------------------------------------------------
  do i = 1, num_years
    year_totals(i) = 0.0
    do j = 1, num_months
      year_totals(i) = year_totals(i) + precip(i, j)
    end do
    year_averages(i) = year_totals(i) / real(num_months)
  end do

  ! ------------------------------------------------------------
  ! Print results with debug jokes and not-serious commentary
  ! ------------------------------------------------------------
  if (debug_mode) then
    print *, ''
    print *, '------ DEBUG MODE: Welcome to the Precipitation Comedy Club ------'
    print *, '1) Why was the equal sign so humble? It wasn''t less than or greater than anyone else.'
    print *, '2) Standard deviation walks into a bar. Bartender: "We don''t serve your type here."'
    print *, '3) I told my Fortran compiler a joke. It threw a segmentation fault. HA!'
    print *, '-----------------------------------------------------------------'
  end if

  print *, ''
  print *, '===================== RAINFALL STATISTICS (1979–2011) ====================='
  print *, 'Mean Precipitation          : ', mean_val, ' mm   (average of all 396 months)'
  print *, 'Median Precipitation        : ', median_val, ' mm   (middle value after sorting)'
  print *, 'Mode Precipitation          : ', mode_val, ' mm   (most frequent to two decimals)'
  print *, 'Standard Deviation          : ', std_dev, ' mm   (spread of the data)'
  print *, '95% Confidence Interval     : [', ci_low, ',', ci_high, '] mm'
  print *, '----------------------------------------------------------------------------'

  print *, 'Monthly Averages (mm over all years):'
  do j = 1, num_months
    print '(A9,2X,F7.3)', month_names(j), month_averages(j)
  end do
  print *, '----------------------------------------------------------------------------'

  print *, 'Yearly Averages (mm over 12 months):'
  do i = 1, num_years
    print '(I4,2X,F7.3)', i + start_year - 1, year_averages(i)
  end do
  print *, '============================================================================'

contains

  ! --------------------------------------------------------------------------
  ! Subroutine: SORT_ARRAY
  ! Purpose: Simple bubble sort to sort real array ascending
  ! --------------------------------------------------------------------------
  subroutine sort_array(arr)
    real, intent(inout) :: arr(:)
    integer :: a, b
    real    :: tmp
    do a = 1, size(arr) - 1
      do b = a + 1, size(arr)
        if (arr(a) > arr(b)) then
          tmp    = arr(a)
          arr(a) = arr(b)
          arr(b) = tmp
        end if
      end do
    end do
  end subroutine sort_array

end program Hot97Oakland

