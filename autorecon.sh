#!/bin/bash


echo Please input the domain you would like to scan:
read domain

subdomainEnum(){
	mkdir -p $domain $domain/subs $domain/recon
	subfinder -d $domain -o $domain/subs/SubfinderResults.txt
	amass enum -d  $domain -o $domain/subs/amassResults.txt
	cat $domain/subs/*.txt > $domain/subs/allSubsFound.txt
}
subdomainEnum

subdomainValidation(){
	cat $domain/subs/allSubsFound.txt |httprobe > $domain/subs/Httprobe.txt
}
subdomainValidation

subdomainPortScanner(){
        cat $domain/subs/allSubsFound.txt | naabu -top-ports 1000 > $domain/subs/Sub_Port.txt
}
subdomainPortScanner




nucleiScan(){
	nuclei -l $domain/subs/Httprobe.txt -t ~/templates/cves -c 100 -o $domain/recon/CVEs.txt
	nuclei -l $domain/subs/Httprobe.txt -t ~/templates/vulnerabilities -c 100 -o $domain/recon/Vulners.txt
	nuclei -l $domain/subs/Httprobe.txt -t ~/templates/security-misconfiguration -c 100 -o $domain/recon/Misconfig.txt
	nuclei -l $domain/subs/Httprobe.txt -t ~/templates/default-credentials -c 100 -o $domain/recon/DefaultCreds.txt
	nuclei -l $domain/subs/Httprobe.txt -t ~/templates/files -c 100 -o $domain/recon/Files.txt
	nuclei -l $domain/subs/Httprobe.txt -t ~/templates/subdomain-takeover -c 100 -o $domain/recon/SubsTakeover.txt
	nuclei -l $domain/subs/Httprobe.txt -t ~/templates/generic-detections -c 100 -o $domain/recon/Generic.txt
nucleiScan

spidering(){
	cat $domain/subs/Httprobe.txt | gospider |tee $domain/recon/spider.txt
	cat $domain/recon/spider.txt | gf xss | tee $domain/recon/xss.txt
	cat $domain/recon/spider.txt | gf sqli | tee $domain/recon/sqli.txt
	cat $domain/recon/spider.txt | gf idor | tee $domain/recon/idor.txt
	cat $domain/recon/spider.txt | gf img-traversal |tee $domain/recon/traversal.txt
	cat $domain/recon/spider.txt | gf interestingEXT |tee $domain/recon/interestingSubs.txt
	cat $domain/recon/spider.txt | gf interestingsubs |tee $domain/recon/interestingSubs.txt
	cat $domain/recon/spider.txt| gf rce | tee $domain/recon/rce.txt
	cat $domain/recon/spider.txt | gf debug_logic | tee $domain/recon/debug.txt
}
spidering
