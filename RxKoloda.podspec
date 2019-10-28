Pod::Spec.new do |spec|
  spec.name         = "RxKoloda"
  spec.version      = "0.1.0"
  spec.summary      = "A reactive wrapper built around Koloda"
  spec.homepage     = "https://github.com/Pubbus/RxKoloda"
  spec.license      =  { :type => "MIT" }
  spec.author             = { "Pubbus" => "lephihungch@gmail.com" }
  spec.platform     = :ios, "8.2"
  spec.source       = { :git => "https://github.com/Pubbus/RxKoloda.git", :tag => "#{spec.version}" }
  spec.source_files  = "Sources/**/*.swift"
  spec.dependency "RxSwift"
  spec.dependency "RxCocoa"
  spec.dependency "Koloda"

end
