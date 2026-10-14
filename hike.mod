module github.com/kanryu/renga-ai

hike 1.0


require github.com/kanryu/hike-ai-stable-diffusion v0.1.0

// Use the Slint bundler supplied by the GUI module.
tool github.com/kanryu/hike-gui-slint/cmd/bds

// Local development replacement. Releases should use the published module.
replace github.com/kanryu/hike-gui-slint => ../hikec-go/hike-gui-slint
replace github.com/kanryu/hike-ai-stable-diffusion => ../hike-ai-stable-diffusion
replace std => ../hikec-go/std
