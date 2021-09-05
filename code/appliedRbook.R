
#We offer an R package called epirhandbook. It includes a function download_book() that downloads the handbook file from our Github repository to your computer.
#This package also contains a function get_data() that downloads all the example data to your computer.
#Run the following code to install our R package epirhandbook from the Github repository appliedepi. This package is not on CRAN, so use the special function p_install_gh() to install it from Github.

# install the latest version of the Epi R Handbook package
pacman::p_install_gh("appliedepi/epirhandbook")
#Now, load the package for use in your current R session:
  
  # load the package for use
pacman::p_load(epirhandbook)
#Next, run the package’s function download_book() (with empty parentheses) to download the handbook to your computer. Assuming you are in RStudio, a window will appear allowing you to select a save location.

# download the offline handbook to your computer
download_book()
