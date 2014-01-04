# Enable an object to be initialized with attributes that are requested from
# another object. Listing the initialized attributes helps to to create clean,
# non-leaking APIs between objects.
#
# The attributes are set to be only privately readable by default to limit what
# the initialized object reveal. Only the readers is set, rather than
# attr_accessor to encourage the state to be immutable where possible.

module CustomInitializers

  # Method similar to attr_accessor that defines the initializer for a class and sets up private attr_readers
  def private_attr_initializer(*attribute_names)
    define_method(:initialize) do |data_obj|
      attribute_names.each do |attribute_name|
        instance_variable_set("@#{attribute_name}", data_obj.send(attribute_name))
      end
    end
    attribute_names.each do |attribute_name|
      attr_reader attribute_name
      private attribute_name
    end
  end

end
