#!/bin/bash
LOG_FILE=$1
HMTL_FILE="${LOG_FILE}.html"

if [[ ${LOG_FILE} == "" ]];then
    echo "syntax: $0 log-file"
    exit 1
fi
if [ ! -f ${LOG_FILE} ];then
    echo "Can't find ${LOG_FILE}"
    exit 1
fi

cat <<EOT >> ${HTML_FILE}
<!DOCTYPE html>
<html>
<head>
<style>
.ant-outcome-failure {
    font-weight: bold;
    color: red;
}

.ant-outcome-success {
    color: #204A87;
}
DIV.expandable-detail {
    display: none;
    background-color: #d3d7cf;
    margin: 0.5em;
    padding: 0.5em;
}
.gradle-outcome-failure {
    font-weight: bold;
    color: red;
}

.gradle-outcome-success {
    color: #204A87;
}

.gradle-task-progress-status {
    color: #ADAD27;
}
#gradle-console-outline-body ul {
    padding-left:5%;
    word-wrap:break-word;
}

#gradle-console-outline-body ul li a {
    word-break:break-all;
}
span.pipeline-new-node {
    color: #9A9999
}
span.pipeline-show-hide {
    visibility: hidden
}
span:hover .pipeline-show-hide {
    visibility: visible
}
</style>
</head>
<body>
<pre id="out" class="console-output">
<div>

EOT

while read -r line;
do
   TIMESTAMP=$(echo "$line" | perl -lne 'print $1 if /^(\d\d:\d\d:\d\d)\s+(.*$)/')  
   MSG=$(echo "$line" | perl -lne 'print $2 if /^(\d\d:\d\d:\d\d)\s+(.*$)/')  
   echo "<span class=\"timestamp\"><b>${TIMESTAMP}</b> </span><span style=\"display: none\">[${TIMESTAMP}]</span> ${MSG}" >> ${HTML_FILE}
done < ${LOG_FILE}

cat <<EOT >> ${HTML_FILE}
</div>
</pre>
</body>
</html>
EOT
scp -q -o StrictHostKeyChecking=no ${HTML_FILE} sbobadilla.dev.box.net:~/
ssh -q -o StrictHostKeyChecking=no sbobadilla.dev.box.net "sudo mv ~/${HTML_FILE} /var/www/http/"
ssh -q -o StrictHostKeyChecking=no sbobadilla.dev.box.net "sudo chown root:root /var/www/http/${HTML_FILE}"
ssh -q -o StrictHostKeyChecking=no sbobadilla.dev.box.net "sudo /usr/sbin/semanage fcontext -a -t httpd_sys_content_t /var/www/http/${HTML_FILE}"
ssh -q -o StrictHostKeyChecking=no sbobadilla.dev.box.net "sudo /usr/sbin/restorecon -Rv  /var/www/html"
rm ${HTML_FILE}
