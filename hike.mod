module github.com/kanryu/renga-ai

hike 1.0

require github.com/kanryu/hike-rdb-sqlite v0.1.0
require github.com/kanryu/hike-ai-stable-diffusion v0.1.0
require github.com/kanryu/hike-images-vips v0.1.0

// Local development replacement. Releases should use the published module.
replace github.com/kanryu/hike-gui-slint => ../hikec-go/hike-gui-slint
replace std => ../hikec-go/std
