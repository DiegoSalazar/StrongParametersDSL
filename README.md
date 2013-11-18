# StrongParametersDsl

The missing Rails controller class method that lets you declare your strong parameters.

## Installation

Add this line to your application's Gemfile:

    gem 'strong_parameters_dsl'

Or install it yourself as:

    $ gem install strong_parameters_dsl

## Usage

When Rails came out with [Strong Parameters](http://edgeapi.rubyonrails.org/classes/ActionController/StrongParameters.html) it just didn't feel Ruby enough.
This gem is a simple workaround that will let you declaratively define your strong parameters as you would your filters.

```ruby
class UsersController < ActionController::Base
  strong_params :user do
    permit :name, :email, comments_attributes: [:comment, :post_id]
  end
  # ... or ...
  strong_params :user, permit: [:name, :email, comments_attributes: [:comment, :post_id]]


  def create
    # the named param method is created based on the argument passed
    # to the strong_params call
    User.create user_params

    ... rest of code ...
  end
end
```

The block passed to ```strong_params``` is evaluated in the context of the ActionController::Parameters instance that is returned by ```params```.
Or more specifically by the strongified instance returned by calling ```params.require(:some_key)```.

There is an issue regarding allowing arbitrary hashes in some keys which was [debated here](https://github.com/rails/rails/issues/9454#issuecomment-14167664).
The solution wasn't very neat but it could be added as an instance method on the Parameters instance and then used as part of this DSL. Ideas welcome.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
