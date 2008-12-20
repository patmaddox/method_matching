# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{method_matching}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Pat Maddox"]
  s.date = %q{2008-12-20}
  s.description = %q{TODO}
  s.email = %q{pat.maddox@gmail.com}
  s.homepage = %q{http://github.com/pat-maddox/method_matching}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{TODO}
  s.files = Dir["[A-Z]*.*", "{bin,generators,lib,test,spec}/**/*"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
