#
# (C) Tenable Network Security, Inc.
#

# Ref: 
# Date: Mon, 09 Jun 2003 12:19:40 +0900
# From: ":: Operash ::" <nesumin@softhome.net>
# To: bugtraq@securityfocus.com
# Subject: [LeapFTP] "PASV" Reply Buffer Overflow Vulnerability
#


include("compat.inc");

if(description)
{
 script_id(11705);
 script_version("$Revision: 1.8 $");
 script_bugtraq_id(7860);
 script_xref(name:"OSVDB", value:"4587");

 script_name(english:"LeapFTP < 2.7.4.x PASV Reply Remote Overflow");

 script_set_attribute(attribute:"synopsis", value:
"The remote host is running an FTP client that is affected by a buffer
overflow vulnerability." );
 script_set_attribute(attribute:"description", value:
"The remote host is running LeapFTP - an FTP client.

There is a flaw in the remote version of this software which may 
allow an attacker to execute arbitrary code on this host.

To exploit it, an attacker would need to set up a rogue FTP
server and have a user on this host connect to it." );
 script_set_attribute(attribute:"see_also", value:"http://marc.theaimsgroup.com/?l=bugtraq&amp;m=105795219412333&amp;w=2" );
 script_set_attribute(attribute:"solution", value:
"Upgrade to version 2.7.4.x or newer as this reportedly fixes the 
issue." );
 script_set_attribute(attribute:"cvss_vector", value: "CVSS2#AV:N/AC:L/Au:N/C:P/I:P/A:P" );

script_end_attributes();

 script_summary(english:"Determines the presence of LeapFTP");
 script_category(ACT_GATHER_INFO);
 script_copyright(english:"This script is Copyright (C) 2003-2009 Tenable Network Security, Inc.");
 script_family(english:"Windows");
 script_dependencies("smb_hotfixes.nasl");
 script_require_keys("SMB/Registry/Enumerated");
 script_require_ports(139, 445);
 exit(0);
}

#

include("smb_func.inc");
include("smb_hotfixes.inc");



rootfile = hotfix_get_programfilesdir();
if(!rootfile) exit(1);
share = ereg_replace(pattern:"^([A-Za-z]):.*", replace:"\1$", string:rootfile);
exe =  ereg_replace(pattern:"^[A-Za-z]:(.*)", replace:"\1\LeapFTP\LeapFTP.exe", string:rootfile);



name 	=  kb_smb_name();
login	=  kb_smb_login();
pass  	=  kb_smb_password();
domain 	=  kb_smb_domain();
port    =  kb_smb_transport();
if(!get_port_state(port))exit(1);

soc = open_sock_tcp(port);
if(!soc)exit(1);

session_init(socket:soc, hostname:name);

r = NetUseAdd(login:login, password:pass, domain:domain, share:share);
if ( r != 1 ) exit(1);


handle = CreateFile (file:exe, desired_access:GENERIC_READ, file_attributes:FILE_ATTRIBUTE_NORMAL,
                     share_mode:FILE_SHARE_READ, create_disposition:OPEN_EXISTING);
if( ! isnull(handle) )
{
 version = GetFileVersion(handle:handle);
 CloseFile(handle:handle);
 if ( version[0] < 2 ||
      (version[0] == 2 && version[1] < 6 ) ||
      (version[0] == 2 && version[1] == 7 && version[2] <= 3 ) )
	security_hole(port);
} 
 
NetUseDel();
