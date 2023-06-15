#!/bin/bash

gh --version > /dev/null 2>&1

if [ $? != 0 ];
then
    echo "kindly install the Github CLI to process further"
fi

sender=nowhemantsharma@gmail.com
receiver=hemantsharmanow@gmail.com # read -p "enter the receivers email address" 
gapp=rrrwlykrdpfaxwgv
sub="Weekly PR Summary"
gh auth login --with-token < gittoken.txt 

gh pr list -L 7 -R https://github.com/microsoft/Microsoft365DSC -s all --json number,title,headRefName,state,isDraft,closed,updatedAt --template \
	'{{tablerow "NUMBER" "TITLE" "headRefName" "STATE" "DRAFT" "CLOSED" "DATE"}}{{range .}}{{tablerow (printf "#%v" .number | autocolor "green") .title .headRefName .state .isDraft .closed (timeago .updatedAt)}}{{end}}' > /tmp/weekly_pr.txt


body="Kindly check the attachment for the weekly PR summary"

file="/tmp/weekly_pr.txt"
    
    MIMEType=`file --mime-type "$file" | sed 's/.*: //'`
    curl -s --url 'smtps://smtp.gmail.com:465' --ssl-reqd \
    --mail-from $sender \
    --mail-rcpt $receiver\
    --user $sender:$gapp \
     -H "Subject: $sub" -H "From: $sender" -H "To: $receiver" -F \
    '=(;type=multipart/mixed' -F "=$body;type=text/plain" -F \
      "file=@$file;type=$MIMEType;encoder=base64" -F '=)'
    