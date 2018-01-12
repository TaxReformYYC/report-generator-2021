# Proptax

Process property assessment reports provided by the City of Calgary and automatically report and visualize on discrepencies in the data.

I currently have three victories before Calgary's [Assessment Review Board](http://www.calgaryarb.ca/eCourtPublic/). Go to [TaxReformYYC](https://taxreformyyc.com) for more information.

This software automatically generates the reports I submit as evidence before the ARB.

# Setup

`proptax` is a command line `ruby` program developed under Ubuntu 16.04. It is free to use and entirely open source, so it is probably deployable on MacOS and maybe Windows with some massaging. If you figure it out, please document the process and submit a pull request. I will gladly add your contribution to this software.

## Dependencies

`proptax` combines and coordinates the output of multiple open source resources. In broad terms, it requires the following packages to generate the reports:

1. `gs`
2. `tesseract`
3. `enscript`
4. `pandoc`
5. `R`

The following commands will install all third party dependencies:

``` 
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
sudo add-apt-repository 'deb [arch=amd64,i386] https://cran.rstudio.com/bin/linux/ubuntu xenial/'
sudo apt update
sudo apt install -y ghostscript tesseract-ocr enscript pandoc r-base r-base-dev r-cran-scales libmagick++-dev mesa-common-dev libglu1-mesa-dev texlive-fonts-recommended texlive-latex-recommended
``` 

### R

`R` does the bulk of the data processing. It has some dependencies that are not available from Ubuntu 16.04 (Xenial) PPAs. They need to be installed into the `R` environment directly.

Execute the following to open the `R` command prompt:

```
R
```

Then, at the `>` prompt, execute the following `R` commands:

```
install.packages('knitr', dependencies = TRUE)
install.packages('scales', dependencies = TRUE)
install.packages('formattable', dependencies = TRUE)
install.packages('ggplot2', dependencies = TRUE)
```

Assuming successful installation, you can exit `R` by holding `Ctrl-D`.

## Install proptax

`proptax` is a `ruby` program. As such, you need to [install ruby](https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-ubuntu-16-04).

You install the latest release of `proptax` like this:

```
gem install proptax
```

# Usage

`proptax` reports-on and visualizes the data contained in residential property reports provided by the City of Calgary. Your property report and those of your neighbours can be obtained at [assessmentsearch.calgary.ca](https://assessmentsearch.calgary.ca).

Last year I made a whole series of super-boring [YouTube tutorials](https://www.youtube.com/playlist?list=PLkQAXLFkBnmiB8O06C2oGAoarBCVO7M9J) on how to collect and process your property data. The collection process has changed slightly, but [the first video](https://www.youtube.com/watch?v=m0zzsL0DYlI&list=PLkQAXLFkBnmiB8O06C2oGAoarBCVO7M9J&index=2) should point you in the right direction. You only get 50 reports per year for some reason, so use 'em all up (and send them to me)!

TODO: More usage instructions to come...

# Development

Install third-party software as with _Setup > Dependencies_, above.

Clone this repository:

```
git clone https://github.com/TaxReformYYC/report-generator-2018.git
```

Install `ruby` dependencies:

```
cd report-generator-2018
bin/setup
```

### Test:

```
bundle exec rake spec
```

### To execute the `proptax` script within the development environment:

```
bundle exec exe/proptax
```

### To build the gem:

```
bundle exec rake build
```

The package will be found in the `pkg/` directory.

### To install this gem onto your local machine, run:

```
bundle exec rake install
```

If that doesn't work, try this:

```
gem install pkg/proptax-0.1.0.gem # Note version number
```

Execute the program:

```
proptax
```

If installed correctly, you will see help instructions.

### To release a new version:

Update the version number in `version.rb`, and then run:

```
bundle exec rake release
```

This will create a `git` tag for the version, push `git` commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org):

# Contributing

Bug reports and pull requests are welcome.

## TODOs:

- Speed up tests. Remove setup redundancies
- Deploy auto CHANGELOG
- DRY out `R` code
- Deploy `tesseract` OCR on rasterized PDFs (as with Windows 7).
- Custom report template documentation
- Auto-install gem's third-party dependencies
- Set up wiki for use on different operating systems
- Dependencies require X11. It would be nice to run this on an Ubuntu 16.04 Server somehow

Suggestions? Contribute or [donate](https://taxreformyyc.com/donate)!

## Future:

- Basic API for property data submission, collection, and retrieval

# Licence

GNU General Public License v3.0
