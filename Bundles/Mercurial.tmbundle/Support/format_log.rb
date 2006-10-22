$bundle        = ENV['TM_BUNDLE_SUPPORT']
$support       = ENV['TM_SUPPORT_PATH']
$work_path     = ENV['WorkPath'] + "/"

msg_count      = 0      # used to count messages and to show tables in alternate colors

require 'erb'
require $bundle+'/hg_helper.rb'
require "#{ENV['TM_BUNDLE_SUPPORT']}/getfontpref.rb"
include HGHelper
include ERB::Util 

begin
  font = %Q|\n<style type="text/css">\npre { font: 11px #{getfontname}; }\n</style>|
  make_head( 'Hg Log', $work_path,
              [ $bundle+'/Stylesheets/hg_style.css',
                $bundle+'/Stylesheets/hg_log_style.css'],
              font + "<script type=\"text/javascript\">\n"+
                 File.open($bundle+'/flip_files.js', 'r').readlines.join+'</script>' )
 
   STDOUT.flush
 
   # hg ouput is formatted with map-cmdline.changelog, then parsed by ERB. Weird but works.
   ERB.new( STDIN.read ).result( binding ).each_line do |l|
      puts l
   end
   
rescue => e
   handle_default_exceptions( e )
ensure
   make_foot()
end
