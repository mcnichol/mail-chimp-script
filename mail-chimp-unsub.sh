#!/bin/bash

export MAIL_CHIMP_KEY='ENTER YOUR API KEY HERE'
export MAIL_CHIMP_UNAME='ENTER YOUR USERNAME HERE'
export MAIL_CHIMP_LIST='ENTER MAIL CHIMP LIST ID HERE'

total_items=$(node -pe 'JSON.parse(process.argv[1]).total_items' "$(CURL --request GET --url https://us11.api.mailchimp.com/3.0/lists/$MAIL_CHIMP_LIST/members --user $MAIL_CHIMP_UNAME:$MAIL_CHIMP_KEY -s)")

while [ $total_items -gt 0 ]; do 
   echo "There are $total_items remaining in MailChimp Unsub List.  Deleting next set..."
   
   #Fire get request grab next ten || < user hashs
   request=$(node -pe 'JSON.parse(process.argv[1]).members' "$(CURL --request GET --url https://us11.api.mailchimp.com/3.0/lists/$MAIL_CHIMP_LIST/members --user $MAIL_CHIMP_UNAME:$MAIL_CHIMP_KEY -s)")
   for var in "${request[@]}"
   do 
      hash=($(echo "${var}" | grep " id:" | grep -o "..................................$" | grep -o "^................................"))
      for myvar in "${hash[@]}"
      do
         CURL --request DELETE --url https://us11.api.mailchimp.com/3.0/lists/$MAIL_CHIMP_LIST/members/$myvar --user MAIL_CHIMP_UNAME:MAIL_CHIMP_KEY -s
      done
   done     
   
   #Request next set of information
   total_items=$(node -pe 'JSON.parse(process.argv[1]).total_items' "$(CURL --request GET --url https://us11.api.mailchimp.com/3.0/lists/$MAIL_CHIMP_LIST/members --user $MAIL_CHIMP_UNAME:MAIL_CHIMP_KEY -s)")
done 

