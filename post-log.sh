#!/bin/bash
export LOG_FILE=$1
export HTML_FILE="/tmp/${LOG_FILE}.html"
export HTML_FILE_NAME="${LOG_FILE}.html"
if [[ ${LOG_FILE} == "" ]];then
    echo "syntax: $0 log-file"
    exit 1
fi
if [ ! -f ${LOG_FILE} ];then
    echo "Can't find ${LOG_FILE}"
    exit 1
fi
echo "write header" >&2
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
echo 2> "write log"
while read -r line;
do
   TIMESTAMP=$(echo "$line" | perl -lne 'print $1 if /^(\d\d:\d\d:\d\d)\s+(.*$)/')
   MSG=$(echo "$line" | perl -lne 'print $2 if /^(\d\d:\d\d:\d\d\s+){0,1}(.*$)/')
   echo "<span class=\"timestamp\"><b>${TIMESTAMP}</b> </span><span style=\"display: none\">[${TIMESTAMP}]</span> <span style=\"color: #333CFF;\">${MSG}</span>" >> ${HTML_FILE}
   printf "%s" "." >&2
done < ${LOG_FILE}
echo >&2 
echo "write footer" >&2 
cat <<EOT >> ${HTML_FILE}
</div>
</pre>
</body>
</html>
EOT
echo "post to web server" >&2 
scp -q -o StrictHostKeyChecking=no ${HTML_FILE} sbobadilla.dev.box.net:${HTML_FILE}
ssh -q -o StrictHostKeyChecking=no sbobadilla.dev.box.net "sudo mv ${HTML_FILE} /var/www/html/"
ssh -q -o StrictHostKeyChecking=no sbobadilla.dev.box.net "sudo chown root:root /var/www/html/${HTML_FILE_NAME}"
ssh -q -o StrictHostKeyChecking=no sbobadilla.dev.box.net "sudo /usr/sbin/semanage fcontext -a -t httpd_sys_content_t /var/www/html/${HTML_FILE_NAME}"
ssh -q -o StrictHostKeyChecking=no sbobadilla.dev.box.net "sudo /usr/sbin/restorecon -Rv  /var/www/html"
rm ${HTML_FILE}

echo "http://sbobadilla.dev.box.net/${HTML_FILE_NAME}"
