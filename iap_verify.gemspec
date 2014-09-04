# -*- encoding: utf-8 -*-
# stub: iap_verify 0.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "iap_verify"
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["WF|Todor Panev"]
  s.date = "2014-09-03"
  s.description = "Verify in app purchase"
  s.email = "toshe@webfactory.mk"
  s.extra_rdoc_files = ["LICENSE", "README.md", "lib/iap_verify.rb", "lib/iap_verify/receipt_ios7.rb"]
  s.files = ["LICENSE", "Manifest", "README.md", "Rakefile", "iap_verify.gemspec", "init.rb", "lib/iap_verify.rb", "lib/iap_verify/receipt_ios7.rb"]
  s.homepage = "https://github.com/WebFactoryMk/iap_verify"
  s.rdoc_options = ["--line-numbers", "--title", "Iap_verify", "--main", "README.md"]
  s.rubyforge_project = "iap_verify"
  s.rubygems_version = "2.3.0"
  s.summary = "Verify in app purchase"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<venice>, [">= 0"])
    else
      s.add_dependency(%q<venice>, [">= 0"])
    end
  else
    s.add_dependency(%q<venice>, [">= 0"])
  end
end
