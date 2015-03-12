if defined?(ChefSpec)
  # config
  def create_rt4_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:rt4_service, :create, resource_name)
  end
end
