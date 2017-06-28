
Pod::Spec.new do |s|
  s.name         = "DPSegmentControl"
  s.version      = "1.0.0"
  s.summary      = "A text field class like Android text field"
  s.description  = "This pod creates a custom textField class that looks like Android textField."
  s.homepage     = "https://github.com/deonisiy162980/DPSegmentControl"
  s.license      = "MIT"
  s.author       = "Denis Petrov"
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/deonisiy162980/DPSegmentControl", :tag => "1.0.0" }
  s.source_files  = "DPSegmentControl", "DPSegmentControl/**/*.{h,m,swift}"
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3' }

end
