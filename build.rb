require "yaml"
require "filewatcher"
require "optparse"

def elm_make(filename, debug, output)
  optionMode = if debug then "--debug" else "--optimize" end
  system "elm make #{filename} #{optionMode} --output=#{output}"
  puts "#{Time.now}: #{filename} compiled."
end

def stylus_make(filename, output)
    system "stylus --compress #{filename} --out #{output}"
    puts "#{Time.now}: #{filename} compiled."
end

def find_setting(config, filename)
  config.find { |item| item["file"] == filename }
end

def all_elm_make(config, debug)
  if config["elm"] != nil then
    config["elm"].each { |item|
      elm_make(item["file"], debug, item["output"])
    }
  end
end

def all_styl_make(config, debug)
  if config["stylus"] != nil then
    config["stylus"].each { |item|
      stylus_make(item["file"], item["output"])
    }
  end
end

def initial_make(config, debug)
  all_elm_make(config, debug)
  all_styl_make(config, debug)
end

debug = false
opt = OptionParser.new
opt.on("-d") { debug = true }

opt.parse!(ARGV)
BUILD_CONFIG = "build_config.yml"

config = YAML.load_file(BUILD_CONFIG)

puts "start watch..."

initial_make(config, debug)

config_watcher = Filewatcher.new(BUILD_CONFIG)
config_thread = Thread.new(config_watcher) { |w|
  w.watch { |filename|
    config = YAML.load_file(BUILD_CONFIG)
    initial_make(config, debug)
  }
}

elmwatcher = Filewatcher.new("src/**/*")
elm_thread = Thread.new(elmwatcher) { |w|
  w.watch { |filename|
    all_elm_make(config, debug)
  }
}

stylwatcher = Filewatcher.new("styl/**/*")
styl_thread = Thread.new(stylwatcher) { |w|
  w.watch { |filename|
    all_styl_make(config, debug)
  }
}

config_thread.join
elm_thread.join
styl_thread.join
