# KtoBlzCheck

`KtoBlzCheck` is a small Ruby extension for Linux (written in C) that provides an interface for
[`libktoblzcheck`](http://ktoblzcheck.sourceforge.net), a library to check German
account numbers and bank codes. It further provides a simple query method to find
bank codes, locations and names

Huge chunks of this RubyGem is based on the original Ruby/C implementation
[rbKtoBlzCheck](https://github.com/krudolph/rbktoblzcheck) by Kim Rudolph.

## Installation

You'll need

- Ruby v1.9.3 or higher (if you still run Ruby 1.8, use rbKtoBlzCheck)
- and `libktoblzcheck` (the package name may vary).

Add this line to your application's Gemfile:

    gem 'ktoblzcheck'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ktoblzcheck

If you get a warning like `Couldn't find header file ktoblzcheck.h`, make sure
you have `libktoblzcheck` installed. You can either fetch this library from
[SourceForge](http://ktoblzcheck.sourceforge.net) or install it on Debian/Ubuntu
with

    # apt-get install -y libktoblzcheck1c2a libktoblzcheck1-dev

You can verify the installation e.g. by calling `locate ktoblzcheck.h`—this should
point to an existing file.

## Usage

    require 'ktoblzcheck'

    @bank_code  = "20030700"
    @account_no = "0"

    puts "Testing Bank Code: #{@bank_code} / Account No. #{@account_no}"

    KtoBlzCheck.new do |kbc|
      name, location = kbc.find(@bank_code)
      if name
        puts "Bank found! #{name} located in #{location}"
      else
        puts "Bank not found!"
      end
      case kbc.check(@bank_code, @account_no)
      when KtoBlzCheck::ERROR
        puts "Failed, bank code and account number don't match"
      when KtoBlzCheck::OK
        puts "Success, valid combination of bank code and account number"
      when KtoBlzCheck::UNKNOWN
        puts "Unknown."
      when KtoBlzCheck::BANK_NOT_KNOWN
        puts "Unknown bank code"
      else
        puts "Never reached :)"
      end
    end

## License

3-clause BSD or GPL (see `LICENSE.txt`)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
