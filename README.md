
# Getting Started
Below are instructions for downloading R, RStudio, data and the packages we will be using.

## R & RStudio
_The instructions for downloading and/or updating R and R studio are more-or-less blatantly copied from the [Setup page](https://datacarpentry.org/ecology-workshop/setup-r-workshop.html) for the [Data Carpentry - Ecology workshops](https://datacarpentry.org/lessons/#ecology-workshop)._

R and RStudio are separate downloads and installations. R is the underlying statistical computing environment, but using R alone is no fun. RStudio is a graphical integrated development environment (IDE) that makes using R much easier and more interactive. **You need to install R before you install RStudio.** After installing both programs, you will need to install some specific R packages within RStudio. Follow the instructions below for your operating system, and then follow the instructions to install tidyverse and download the dugout data.

### Windows

#### *If you already have R and RStudio installed:*

1. Open RStudio, click on “Help” > “Check for updates”. (If you don't see "Check for updates" under "Help," you need to update RStudio [here](https://www.rstudio.com/products/rstudio/download/#download), like I did!)
2. To check which version of R you are using, start RStudio and the first thing that appears in the console indicates the version of R you are running. Alternatively, you can type sessionInfo(), which will also display which version of R you are running. If you're running anything below R-4.0.0, follow the steps below. Ideally, you will be running R-4.0.5.
    * Type the following into the console and run: `install.packages("installr")`
    * After you've installed the `installr` package, run `installr::updateR()` in the console. This will start the updating process of your R installation by: “finding the latest R version, downloading it, running the installer, deleting the installation file, copy and updating old packages to the new R installation.”

Once you've done this, be sure to install the packages. 

#### *If you don’t have R and RStudio installed:*

1. Download R from the [CRAN website](https://cran.r-project.org/bin/windows/base/) and run the .exe file that was just downloaded
2. Go to the [RStudio download page](https://www.rstudio.com/products/rstudio/download/#download)
    * Under Installers, select RStudio x.yy.zzz - Windows Vista/7/8/10 (where x, y, and z represent version numbers)
    * Double click the file to install it
    * Once it’s installed, open RStudio to make sure it works and you don’t get any error messages.

Once you've done this, be sure to install the packages. 

#### macOS

*If you already have R and RStudio installed:*

1. Open RStudio, click on “Help” > “Check for updates”. (If you don't see "Check for updates" under "Help," you need to update RStudio [here](https://www.rstudio.com/products/rstudio/download/#download), like I did!)
2. To check the version of R you are using, start RStudio and the first thing that appears on the terminal indicates the version of R you are running. Alternatively, you can type sessionInfo(), which will also display which version of R you are running. If you're running anything below 4.0.0, install an updated version from [here](https://cloud.r-project.org/bin/macosx/). Ideally, you will be running R-4.0.5.

Once you've done this, be sure to install the packages. 

*If you don’t have R and RStudio installed:*

1. Download R-4.0.5 from [here](https://cloud.r-project.org/bin/macosx/).
    * Select the .pkg file for the latest R version
    * Double click on the downloaded file to install R
2. Go to the [RStudio download page](https://www.rstudio.com/products/rstudio/download/#download)
    * Under Installers, select RStudio x.yy.zzz - Mac OS X 10.6+ (64-bit) (where x, y, and z represent version numbers)
    * Double click the file to install RStudio
    * Once it’s installed, open RStudio to make sure it works and you don’t get any error messages.

Once you've done this, be sure to install the packages. 

#### Linux
Follow the instructions for your distribution from CRAN, they provide information to get the most recent version of R for common distributions. For most distributions, you could use your package manager (e.g., for Debian/Ubuntu run sudo apt-get install r-base, and for Fedora sudo yum install R), but we don’t recommend this approach as the versions provided by this are usually out of date. In any case, make sure you have at least R 3.5.1.
Go to the [RStudio download page](https://www.rstudio.com/products/rstudio/download/#download)
* Under Installers select the version that matches your distribution, and install it with your preferred method (e.g., with Debian/Ubuntu sudo dpkg -i rstudio-x.yy.zzz-amd64.deb at the terminal).
* Once it’s installed, open RStudio to make sure it works and you don’t get any error messages.

Once you've done this, be sure to install the packages. 

### The `tidyverse` packages

After installing R and RStudio, you need to install the tidyverse. We'll talk more about what the tidyverse is later!

Start RStudio by double-clicking the icon and then, in the "Console," type: `install.packages("tidyverse")` and hit Enter. You can also do this by going to "Tools" -> "Install Packages" and typing the names of the packages you want to install.

### Dugout Data
We'll be using some dugout data from 2017 during these sessions. We will be reading the data into R from the URL to start off. You can get to the raw data (and the URL you will need to copy) by clicking [here](https://raw.githubusercontent.com/bleds22e/FAST_lab_training/master/data/Dugout_master%202017.csv).
