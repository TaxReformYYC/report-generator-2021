# Proptax

Process property assessment reports provided by the City of Calgary and automatically report and visualize on discrepencies in the data.

I currently have three victories before Calgary's [Assessment Review Board](http://www.calgaryarb.ca/eCourtPublic/). Go to [TaxReformYYC](https://taxreformyyc.com) for more information.

# In progress...

In open-sourcing this software, I've had to make improvements to tests and documentation. Keep checking back for updates.

# Dependencies

This software was developed on Ubuntu 16.04. It requires the following packages to generate the reports:

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
sudo apt install -y ghostscript tesseract-ocr enscript pandoc r-base r-base-dev r-cran-ggplot2 r-cran-scales libmagick++-dev mesa-common-dev libglu1-mesa-dev
``` 

## R

`R` has some dependencies that are not available from Ubuntu 16.04 (Xenial) PPAs. They need to be installed into the `R` environment directly.

Execute the following to open the `R` command prompt:

```
R
```

Execute the following `R` commands:

```
install.packages('knitr', dependencies = TRUE)
install.packages('scales', dependencies = TRUE)
```

Assuming successful installation, you can exit `R` by holding `Ctrl-D`.

# Installation (coming soon)

Add this line to your application's Gemfile:

```ruby
gem 'proptax'
```

And then execute:

```
bundle
```

Or install it yourself as:

```
gem install proptax
```

# Usage

TODO: Write usage instructions here

# Development

After checking out the repo, install dependencies:

```
bin/setup
```

Test:

```
bundle exec rake spec
```

To execute the `proptax` script within the development environment:

```
bundle exec exe/proptax
```

To install this gem onto your local machine, run:

```
bundle exec rake install
gem install pkg/proptax-0.1.0.gem
proptax
```

To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

# Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/taxreformyyc/report-generator-2018.

# Licence

GNU General Public License v3.0

