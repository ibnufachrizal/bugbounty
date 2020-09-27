# Awesome One-liner Bug Bounty [![Awesome](https://awesome.re/badge-flat2.svg)](https://awesome.re)
> A collection of awesome one-liner scripts especially for bug bounty.

This repository stores and houses various one-liner for bug bounty tips provided by me as well as contributed by the community. Your contributions and suggestions are heartily♥ welcome.

---

### SSRF
> @ibnufachrizal

```bash
gau ea.com -s | head -n 5000 > domain.txt; cat domain.txt | sort -u | grep -a -i \=http | httpx -status-code -mc 200,301,302 > result.txt
```

### Scrape File
> @ibnufachrizal

```bash
subfinder -d ea.com | assetfinder -subs-only | gau | grep ".json" | httpx -status-code -mc 200
```

### Get Subdomain
> @ibnufachrizal

```bash
curl -s https://api.securitytrails.com/v1/domain/gcox.com/subdomains?apikey=UdbuQzjz44qbSOlGLZ46PnsqCrhzu9E4 | jq '.subdomains[]' | cut -d '"' -f2 | awk -v myvar="gcox.com" '{print $0"."myvar}' | sort -u | httpx -status-code
```


