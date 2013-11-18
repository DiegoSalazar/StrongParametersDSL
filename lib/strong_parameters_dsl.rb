require "strong_parameters_dsl/version"

# Example:
# class UsersController < ActionController::Base
#   strong_params :user do
#     permit :name, :email, comments_attributes: [:comment, :post_id]
#   end
#
#   def create
#     User.create user_params
#   end
# end

module StrongParametersDsl
  class Railtie < Rails::Railtie
    initializer "strong_parameters_dsl.initializer" do |app|
      ActionController::Base.class_eval do
        def self.strong_params(name, &block)
          strongified = params.require name
          strongified.instance_exec &block if block_given?
          define_method("#{name}_params") { strongified }
        end
      end
    end
  end 
end
