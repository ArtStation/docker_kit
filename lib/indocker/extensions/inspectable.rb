module Indocker::Extensions::Inspectable
  def inspect
    data = {}
    instance_variables.each do |variable|
      data[variable.to_s.gsub('@', '').to_sym] = instance_variable_get(variable)
    end

    "#{self.class.to_s}<#{data.inspect}>"
  end
end