[all]
%{ for ip in servers~}
${ip}
%{ endfor ~}
