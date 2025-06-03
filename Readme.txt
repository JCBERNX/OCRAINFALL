OCRAINFALL (1979–2011)

This repository contains a Fortran program named Hot97Oakland.f90. It reads county-level monthly precipitation data in millimeters derived from the NLDAS daily precipitation dataset for years 1979 through 2011. The data is obtained from CDC WONDER (https://wonder.cdc.gov/nasa-precipitation.html) and aggregated from daily to monthly totals.

The program calculates the following summary statistics over all 396 monthly values (33 years × 12 months):

Mean, Median, Mode
Standard Deviation (sample-based)
95 percent Confidence Interval for the mean
Monthly averages (averaged over 33 years for each calendar month)
Yearly averages (averaged over 12 months for each year from 1979 to 2011)

When run in debug mode, it also prints three not-serious math jokes and light commentary.

Data is read from a CSV file named OAKLAND_MONTHLY.csv. The program does not hardcode precipitation values. To run this on a different county or time period, update the CSV file accordingly.

REPOSITORY STRUCTURE

Hot97Oakland.f90 Fortran source code
OAKLAND_MONTHLY.csv Input file with 396 rows of data
README.txt This documentation
LICENSE.txt MIT license terms

DATA SOURCE AND FORMAT

Data is sourced from the NLDAS daily precipitation portal on CDC WONDER:
https://wonder.cdc.gov/nasa-precipitation.html

Daily precipitation values are aggregated to monthly totals for each county from January 1979 through December 2011, producing exactly 396 data points.

The CSV file must be named OAKLAND_MONTHLY.csv and located in the same directory as Hot97Oakland.f90. It must include a header row with the following three columns:

Year,Month,Precip_mm

Each line after the header must contain the year (e.g., 1979), month (1 through 12), and the monthly precipitation in millimeters.

Example:
1979,1,12.34
1979,2,15.68
...
2011,12,10.22

COMPILATION AND EXECUTION

Step 1: Ensure a Fortran compiler is installed (GNU Fortran recommended). On Ubuntu or Debian:
sudo apt update
sudo apt install gfortran

Step 2: Move Hot97Oakland.f90 and OAKLAND_MONTHLY.csv to the same working directory.

Step 3: Navigate to that directory in your terminal:
cd ~/path/to/project

Step 4: Compile the source code:
gfortran -o Hot97Oakland Hot97Oakland.f90

Step 5: Run the executable:
./Hot97Oakland

The program will print debug-mode jokes followed by summary statistics.

EXAMPLE OUTPUT

------ DEBUG MODE: Welcome to the Precipitation Comedy Club ------

    Why was the equal sign so humble? It wasn’t less than or greater than anyone else.

    Standard deviation walks into a bar. Bartender: "We don’t serve your type here."

    I told my Fortran compiler a joke. It threw a segmentation fault.

====================== RAINFALL STATISTICS (1979–2011) ======================
Mean Precipitation: 3.190 mm
Median Precipitation: 3.205 mm
Mode Precipitation: 4.050 mm
Standard Deviation: 1.674 mm
95 Percent Confidence Interval: [3.025, 3.355] mm

Monthly Averages (mm over all years):
January 2.772 mm
February 2.820 mm
March 3.159 mm
April 3.025 mm
May 3.327 mm
June 3.353 mm
July 3.224 mm
August 3.707 mm
September 3.756 mm
October 3.078 mm
November 3.008 mm
December 3.055 mm

Yearly Averages (mm over 12 months):
1979 3.508 mm
1980 3.944 mm
1981 3.038 mm
1982 3.255 mm
1983 3.364 mm
1984 3.158 mm
1985 3.338 mm
1986 2.771 mm
1987 3.251 mm
1988 4.229 mm
1989 2.021 mm
1990 3.710 mm
1991 2.561 mm
1992 2.435 mm
1993 2.847 mm
1994 3.588 mm
1995 3.807 mm
1996 3.961 mm
1997 3.124 mm
1998 2.582 mm
1999 2.296 mm
2000 3.957 mm
2001 3.706 mm
2002 3.862 mm
2003 2.799 mm
2004 3.424 mm
2005 3.300 mm
2006 3.009 mm
2007 2.847 mm
2008 3.470 mm
2009 3.682 mm
2010 2.339 mm
2011 2.097 mm

LICENSE

This project is released under the MIT License. See LICENSE.txt for the full license text.

ASSUMPTIONS AND LIMITATIONS

The program expects exactly 396 data points (one for each month from 1979 to 2011).
If a line is missing or invalid, the program will skip it and assign zero.
The CSV must contain no blank lines and follow the required header format.
All monthly precipitation totals are assumed to be correct and non-negative.

EXTENSIONS AND NEXT STEPS

You can adapt this code for seasonal anomaly detection, regional comparisons, or plot generation.
For extended analysis, consider exporting summary results and working with Python or R.
To analyze multiple counties, generate separate CSV files per county and run them one at a time or modify the code to accept arguments.

ABOUT THE AUTHOR

Joey Colby Bernert is a limited license clinical social worker and MPH student at Michigan State University. Their focus is rural health, public health data modeling, and policy evaluation. They build statistical models from FOIA-acquired datasets and tutor mathematics at the community college level.
