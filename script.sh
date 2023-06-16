#!/bin/bash

gh --version > /dev/null 2>&1

if [ $? != 0 ];
then
    echo "kindly install the Github CLI to process further"
    exit 1
fi

gh auth status > /dev/null 2>&1

if [ $? != 0 ];
then
    if [ -s github-token.txt ]; 
    then
        gh auth login --with-token < github-token.txt > /dev/null 2>&1
        if [ $? != 0 ]
        then
        echo "To get started with GitHub CLI, please run:  gh auth login"
        echo "Alternatively, populate the GH_TOKEN environment variable with a GitHub API authentication token."
        echo "Alternatively, add a working github token in the github-token.txt file"
        echo "If github-token.txt doesn't exist then create the file and add the github token in it."
        # Note: Adding token in the clear text format is not recommended this is for just demonstration only kindly follow the best security practices.
        exit 1
        fi
    else
        echo "To get started with GitHub CLI, please run:  gh auth login"
        echo "Alternatively, populate the GH_TOKEN environment variable with a GitHub API authentication token."
        echo "Alternatively, add a working github token in the github-token.txt file"
        echo "If github-token.txt doesn't exist then create the file and add the github token in it."
        exit 1
    fi
fi


sender=nowhemantsharma@gmail.com
receiver=${receiver:="hemantsharmanow@gmail.com"}
# receiver=hemantsharmanow@gmail.com  # read -p "Enter the receiver's email address" receiver
gapp=rrrwlykrdpfaxwgv               #not secure but for demo purpose kept it as clear text. 
sub="Weekly PR Summary"



gh pr list -L 7 -R https://github.com/microsoft/Microsoft365DSC -s all --json number,title,headRefName,state,isDraft,closed,updatedAt --template \
	'{{tablerow "NUMBER" "TITLE" "headRefName" "STATE" "DRAFT" "CLOSED" "DATE"}}{{range .}}{{tablerow (printf "#%v" .number | autocolor "green") .title .headRefName .state .isDraft .closed (timeago .updatedAt)}}{{end}}' > weekly_pr.txt


body="Kindly check the attachment for the weekly PR summary"

file="weekly_pr.txt"
    
    MIMEType=`file --mime-type "$file" | sed 's/.*: //'`
    curl -s --url 'smtps://smtp.gmail.com:465' --ssl-reqd \
    --mail-from $sender \
    --mail-rcpt $receiver\
    --user $sender:$gapp \
     -H "Subject: $sub" -H "From: $sender" -H "To: $receiver" -F \
    '=(;type=multipart/mixed' -F "=$body;type=text/plain" -F \
      "file=@$file;type=$MIMEType;encoder=base64" -F '=)'
    