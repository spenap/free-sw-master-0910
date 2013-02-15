#/usr/bin/env python
import mailbox
import email
from email.Utils import getaddresses, parsedate_tz
import datetime

fileobj=open("/home/spenap/2005-June.txt","r")

mbox = mailbox.PortableUnixMailbox(fileobj,email.message_from_file)
message=mbox.next()
ms=message.get_unixfrom()

if ms != None:
	_,date_to_parse = ms.split("  ",1)
parsed_date = parsedate_tz(date_to_parse)
print parsed_date
