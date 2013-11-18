require "strong_parameters_dsl/version"

module StrongParametersDsl
  class Railtie < Rails::Railtie
    initializer "strong_parameters_dsl.initializer" do |app|
      ActionController::Base.class_eval do
        # Examples
        # ========
        #
        #     class UsersController < ActionController::Base
        #       strong_params :user do
        #         permit :name, :email, comments_attributes: [:comment, :post_id]
        #       end
        #       ... or ...
        #       strong_params :user, permit: [name, :email, comments_attributes: [:comment, :post_id]]
        #      
        #       # you can also declare a key whose value is a hash with arbitrary keys
        #       strong_params :activity, any: [:api_log], permit: [:event, :timestamp, :ip_address]
        #      
        #
        #       def create
        #         # the named param method is created based on the argument passed
        #         # to the strong_params call
        #         User.create user_params
        #
        #         ... rest of code ...
        #       end
        #     end
        #
        def self.strong_params(name, options = {}, &block)
          param_method_name = "#{name}_params".to_sym

          define_method param_method_name do
            params.require(name).tap do |strongified|
              if block_given?
                strongified.instance_exec &block
              else
                strongified.permit *Array(options[:permit])
                
                # shortcut to adding a key whose value is a hash with arbitrary keys
                if options[:any].present?
                  Array(options[:any]).map { |key| strongified[key] = params[name][key] }
                end
              end
            end
          end

          private param_method_name
        end
      end
    end
  end 
end
