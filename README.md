# Proptax

Process property assessment reports provided by the City of Calgary and automatically report and visualize on discrepencies in the data.

I currently have three victories before Calgary's [Assessment Review Board](http://www.calgaryarb.ca/eCourtPublic/). Go to [TaxReformYYC](https://taxreformyyc.com) for more information.

## In progress...

In open-sourcing this software, I've had to make improvements to tests and documentation. Keep checking back for updates.

## Dependencies

This software was developed on Ubuntu 16.04. The following dependencies

### Third party

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
sudo apt install -y ghostscript tesseract-ocr enscript pandoc r-base r-base-dev r-cran-ggplot2 libmagick++-dev #xorg libx11-dev libglu1-mesa-dev r-cran-rcpp gdebi-core
``` 

### R

Knitr:

```
wget https://launchpad.net/ubuntu/+archive/primary/+files/r-cran-knitr_1.15.1-2build1_amd64.deb
sudo dpkg -i r-cran-knitr_1.15.1-2build1_amd64.deb
sudo apt install -f
```


R has a bunch of its own packages, which are needed to generate the graphs and reports.

At the `R` command prompt:

```
R
```

Execute the following `R` commands:

```
install.packages('knitr', dependencies = TRUE)
install.packages('scales', dependencies = TRUE)
install.packages('formattable', dependencies = TRUE)
#install.packages('ggplot2', dependencies = TRUE)
```


## Installation

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

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/proptax.
